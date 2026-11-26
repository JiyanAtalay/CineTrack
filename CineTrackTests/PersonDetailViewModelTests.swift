//
//  PersonDetailViewModelTests.swift
//  CineTrackTests
//
//  Created by Mehmet Jiyan Atalay on 25.11.2026.
//

import Foundation
import SwiftData
import Testing
@testable import CineTrack

@Suite("PersonDetailViewModel Tests")
@MainActor
struct PersonDetailViewModelTests {

    private struct TestError: Error {}

    private static let tr = PersonDetailViewModel.primaryLanguage
    private static let en = PersonDetailViewModel.fallbackLanguage

    private static func person(biography: String) -> PersonDetailResponse {
        PersonDetailResponse(id: 10, name: "Christopher Nolan", biography: biography)
    }

    private static func credit(_ id: Int, popularity: Double, job: String? = nil) -> PersonMovieCredit {
        PersonMovieCredit(id: id, title: "Movie \(id)", popularity: popularity, job: job)
    }

    private func makeService(
        trBiography: String = "Türkçe biyografi",
        cast: [PersonMovieCredit] = [],
        crew: [PersonMovieCredit] = []
    ) -> MockPersonService {
        let service = MockPersonService()
        service.details[Self.tr] = Self.person(biography: trBiography)
        service.credits = PersonMovieCreditsResponse(cast: cast, crew: crew)
        return service
    }

    @Test("Acting role lists only cast credits")
    func actingUsesCast() async {
        let service = makeService(
            cast: [Self.credit(1, popularity: 5)],
            crew: [Self.credit(2, popularity: 9, job: "Director")]
        )
        let viewModel = PersonDetailViewModel(service: service)

        await viewModel.load(id: 10, role: .acting)

        #expect(viewModel.movies.map(\.id) == [1])
        #expect(viewModel.isLoading == false)
        #expect(viewModel.errorMessage == nil)
    }

    @Test("Directing role lists only crew credits with Director job")
    func directingUsesDirectorCrew() async {
        let service = makeService(
            cast: [Self.credit(1, popularity: 5)],
            crew: [
                Self.credit(2, popularity: 9, job: "Director"),
                Self.credit(3, popularity: 8, job: "Writer"),
                Self.credit(4, popularity: 7, job: "Producer")
            ]
        )
        let viewModel = PersonDetailViewModel(service: service)

        await viewModel.load(id: 10, role: .directing)

        #expect(viewModel.movies.map(\.id) == [2])
    }

    @Test("Movies are sorted by popularity, most popular first")
    func sortedByPopularity() async {
        let service = makeService(cast: [
            Self.credit(1, popularity: 2),
            Self.credit(2, popularity: 50),
            Self.credit(3, popularity: 10)
        ])
        let viewModel = PersonDetailViewModel(service: service)

        await viewModel.load(id: 10, role: .acting)

        #expect(viewModel.movies.map(\.id) == [2, 3, 1])
    }

    @Test("Same movie appearing twice is listed once")
    func duplicatesRemoved() async {
        let service = makeService(crew: [
            Self.credit(1, popularity: 5, job: "Director"),
            Self.credit(1, popularity: 5, job: "Director"),
            Self.credit(2, popularity: 3, job: "Director")
        ])
        let viewModel = PersonDetailViewModel(service: service)

        await viewModel.load(id: 10, role: .directing)

        #expect(viewModel.movies.map(\.id) == [1, 2])
    }

    @Test("Empty Turkish biography falls back to English")
    func biographyFallsBackToEnglish() async {
        let service = makeService(trBiography: "  ")
        service.details[Self.en] = Self.person(biography: "English biography")
        let viewModel = PersonDetailViewModel(service: service)

        await viewModel.load(id: 10, role: .acting)

        #expect(viewModel.person?.biography == "English biography")
        #expect(service.requestedLanguages == [Self.tr, Self.en])
    }

    @Test("Turkish biography present: no English request")
    func noFallbackWhenTurkishPresent() async {
        let service = makeService(trBiography: "Türkçe biyografi")
        let viewModel = PersonDetailViewModel(service: service)

        await viewModel.load(id: 10, role: .acting)

        #expect(viewModel.person?.biography == "Türkçe biyografi")
        #expect(service.requestedLanguages == [Self.tr])
    }

    @Test("Failed English fallback keeps the Turkish data")
    func fallbackErrorIsIgnored() async {
        let service = makeService(trBiography: "", cast: [Self.credit(1, popularity: 1)])
        service.errorsByLanguage[Self.en] = TestError()
        let viewModel = PersonDetailViewModel(service: service)

        await viewModel.load(id: 10, role: .acting)

        #expect(viewModel.person?.name == "Christopher Nolan")
        #expect(viewModel.person?.biography == "")
        #expect(viewModel.movies.count == 1)
        #expect(viewModel.errorMessage == nil)
    }

    @Test("Service error sets errorMessage")
    func serviceError() async {
        let service = makeService()
        service.error = TestError()
        let viewModel = PersonDetailViewModel(service: service)

        await viewModel.load(id: 10, role: .acting)

        #expect(viewModel.person == nil)
        #expect(viewModel.movies.isEmpty)
        #expect(viewModel.errorMessage != nil)
        #expect(viewModel.isLoading == false)
    }

    @Test("Watched count only includes this person's watched movies")
    func watchedCount() async throws {
        let container = try ModelContainer(
            for: WatchlistMovie.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        let repository = WatchlistRepository(context: container.mainContext)

        func detail(_ id: Int) -> MovieDetailResponse {
            MovieDetailResponse(
                id: id, title: "Movie \(id)", overview: "", posterPath: nil, backdropPath: nil,
                releaseDate: nil, voteAverage: 0, runtime: nil, genres: []
            )
        }

        repository.setStatus(.watched, for: detail(1), directorName: nil)   // listede, izlendi
        repository.setStatus(.planned, for: detail(2), directorName: nil)   // listede, planlandı
        repository.setStatus(.watched, for: detail(99), directorName: nil)  // listede değil

        let service = makeService(cast: [
            Self.credit(1, popularity: 3),
            Self.credit(2, popularity: 2),
            Self.credit(3, popularity: 1)
        ])
        let viewModel = PersonDetailViewModel(service: service)
        viewModel.configure(watchListRepository: repository)

        await viewModel.load(id: 10, role: .acting)
        #expect(viewModel.watchedCount == 1)

        repository.setStatus(.watched, for: detail(3), directorName: nil)
        viewModel.refreshWatchedCount()
        #expect(viewModel.watchedCount == 2)
    }
}
