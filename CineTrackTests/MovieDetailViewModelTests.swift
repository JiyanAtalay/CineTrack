//
//  MovieDetailViewModelTests.swift
//  CineTrackTests
//
//  Created by Mehmet Jiyan Atalay on 6.07.2026.
//

import Testing
@testable import CineTrack

@Suite("MovieDetailViewModel Tests")
struct MovieDetailViewModelTests {

    private static let batman = MovieDetailResponse(
        id: 1,
        title: "Batman",
        overview: "",
        posterPath: nil,
        backdropPath: nil,
        releaseDate: nil,
        voteAverage: 8,
        runtime: nil,
        genres: []
    )

    @Test("Load movie successfully")
    @MainActor
    func loadMovieSuccess() async {
        let service = MockMovieDetailService()
        service.movie = Self.batman

        let viewModel = MovieDetailViewModel(service: service)
        await viewModel.loadMovie(id: 1)

        #expect(viewModel.movie?.title == "Batman")
        #expect(viewModel.errorMessage == nil)
        #expect(viewModel.isLoading == false)
    }

    @Test("Set watch status to planned and toggle it off")
    @MainActor
    func toggleWatchlist() async {
        let service = MockMovieDetailService()
        service.movie = Self.batman

        let repository = MockWatchlistRepository()
        let viewModel = MovieDetailViewModel(service: service)
        viewModel.configure(watchListRepository: repository)

        await viewModel.loadMovie(id: 1)

        viewModel.setWatchStatus(.planned)
        #expect(viewModel.watchStatus == .planned)
        #expect(viewModel.isInWatchlist)

        viewModel.setWatchStatus(.planned)
        #expect(viewModel.watchStatus == nil)
        #expect(!viewModel.isInWatchlist)
    }

    @Test("Director name is loaded from credits and passed to repository")
    @MainActor
    func directorNamePassedToRepository() async {
        let service = MockMovieDetailService()
        service.movie = Self.batman
        service.credits = CreditsResponse(
            cast: [],
            crew: [
                CrewMember(id: 10, name: "Wally Pfister", job: "Director of Photography", profilePath: nil),
                CrewMember(id: 11, name: "Christopher Nolan", job: "Director", profilePath: nil)
            ]
        )

        let repository = MockWatchlistRepository()
        let viewModel = MovieDetailViewModel(service: service)
        viewModel.configure(watchListRepository: repository)

        await viewModel.loadMovie(id: 1)
        #expect(viewModel.directorName == "Christopher Nolan")

        viewModel.setWatchStatus(.watched)
        #expect(repository.lastDirectorName == "Christopher Nolan")
        #expect(viewModel.watchStatus == .watched)

        viewModel.toggleFavorite()
        #expect(viewModel.isFavorite)
        #expect(repository.lastDirectorName == "Christopher Nolan")
    }
}
