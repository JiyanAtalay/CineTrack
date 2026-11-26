//
//  TonightViewModelTests.swift
//  CineTrackTests
//
//  Created by Mehmet Jiyan Atalay on 26.11.2026.
//

import Foundation
import Testing
import SwiftData
@testable import CineTrack

@Suite("TonightViewModel Tests")
@MainActor
struct TonightViewModelTests {

    private struct TestError: LocalizedError {
        var errorDescription: String? { "Boom" }
    }

    // MARK: Helpers

    private static func movie(_ id: Int, poster: String? = "/poster.jpg") -> Movie {
        Movie(
            id: id,
            title: "Movie \(id)",
            overview: "",
            posterPath: poster,
            backdropPath: nil,
            releaseDate: "2020-01-01",
            voteAverage: 7,
            genreIDs: [],
            popularity: 1
        )
    }

    private static func detail(_ id: Int) -> MovieDetailResponse {
        MovieDetailResponse(
            id: id,
            title: "Movie \(id)",
            overview: "",
            posterPath: "/poster.jpg",
            backdropPath: nil,
            releaseDate: "2020-01-01",
            voteAverage: 7,
            runtime: 120,
            genres: [Genre(id: 18, name: "Drama")]
        )
    }

    private static func response(_ movies: [Movie], page: Int = 1, totalPages: Int = 1) -> TrendingMoviesResponse {
        TrendingMoviesResponse(page: page, results: movies, totalPages: totalPages, totalResults: movies.count * totalPages)
    }

    private func makeViewModel(
        service: MockTonightService,
        detailService: MockMovieDetailService? = nil,
        store: MockTonightFilterStore? = nil,
        randomPage: @escaping (ClosedRange<Int>) -> Int = { $0.upperBound }
    ) -> TonightViewModel {
        // Varsayılan argümanlar nonisolated bağlamda değerlendirildiği için
        // MainActor'a bağlı mock'lar burada, fonksiyon gövdesinde oluşturulur.
        let resolvedDetailService = detailService ?? {
            let service = MockMovieDetailService()
            service.movie = Self.detail(1)
            return service
        }()

        return TonightViewModel(
            service: service,
            detailService: resolvedDetailService,
            filterStore: store ?? MockTonightFilterStore(),
            randomPage: randomPage,
            pickMovie: { $0.first }
        )
    }

    // MARK: Tests

    @Test("Suggestion without filters loads a movie and its detail")
    func suggestWithoutFilters() async {
        let service = MockTonightService()
        service.pages[1] = Self.response([Self.movie(1)])

        let detailService = MockMovieDetailService()
        detailService.movie = Self.detail(1)
        detailService.credits = CreditsResponse(
            cast: [],
            crew: [CrewMember(id: 5, name: "Director X", job: "Director", profilePath: nil)]
        )

        let viewModel = makeViewModel(service: service, detailService: detailService)
        await viewModel.suggestAnother()

        #expect(viewModel.movie?.id == 1)
        #expect(viewModel.detail?.runtime == 120)
        #expect(viewModel.directorName == "Director X")
        #expect(viewModel.errorMessage == nil)
        #expect(viewModel.isLoading == false)
        #expect(service.requestedFilters.first == DiscoverFilters.none)
    }

    @Test("Initial load also fetches genres")
    func initialLoadFetchesGenres() async {
        let service = MockTonightService()
        service.genres = [Genre(id: 35, name: "Komedi"), Genre(id: 28, name: "Aksiyon")]
        service.pages[1] = Self.response([Self.movie(1)])

        let viewModel = makeViewModel(service: service)
        await viewModel.loadInitial()

        #expect(viewModel.genres.map(\.name) == ["Aksiyon", "Komedi"])
        #expect(viewModel.movie?.id == 1)

        // İkinci çağrı yeni film çekmez.
        await viewModel.loadInitial()
        #expect(service.requestedPages == [1])
    }

    @Test("Random page is picked within TMDB's 500 page limit")
    func randomPageIsCapped() async {
        let service = MockTonightService()
        service.pages[1] = Self.response([Self.movie(1)], totalPages: 900)
        service.pages[500] = Self.response([Self.movie(500)], page: 500, totalPages: 900)

        let viewModel = makeViewModel(service: service, randomPage: { $0.upperBound })
        await viewModel.suggestAnother()

        #expect(service.requestedPages == [1, 500])
        #expect(viewModel.movie?.id == 500)
    }

    @Test("Watched movies are never suggested")
    func watchedMoviesExcluded() async throws {
        let container = try ModelContainer(
            for: WatchlistMovie.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        let repository = WatchlistRepository(context: container.mainContext)
        repository.setStatus(.watched, for: Self.detail(1), directorName: nil)

        let service = MockTonightService()
        service.pages[1] = Self.response([Self.movie(1), Self.movie(2)])

        let viewModel = makeViewModel(service: service)
        viewModel.configure(watchListRepository: repository)
        await viewModel.suggestAnother()

        #expect(viewModel.movie?.id == 2)
    }

    @Test("Movies without a poster are skipped")
    func moviesWithoutPosterSkipped() async {
        let service = MockTonightService()
        service.pages[1] = Self.response([Self.movie(1, poster: nil), Self.movie(2)])

        let viewModel = makeViewModel(service: service)
        await viewModel.suggestAnother()

        #expect(viewModel.movie?.id == 2)
    }

    @Test("Already suggested movies are not repeated in the same session")
    func noRepeatsInSession() async {
        let service = MockTonightService()
        service.pages[1] = Self.response([Self.movie(1), Self.movie(2)])

        let viewModel = makeViewModel(service: service)

        await viewModel.suggestAnother()
        #expect(viewModel.movie?.id == 1)

        await viewModel.suggestAnother()
        #expect(viewModel.movie?.id == 2)

        await viewModel.suggestAnother()
        #expect(viewModel.movie == nil)
        #expect(viewModel.isEmptyResult)
    }

    @Test("Applying filters saves them, uses them and resets the session")
    func applyFilters() async {
        let service = MockTonightService()
        service.pages[1] = Self.response([Self.movie(1)])

        let store = MockTonightFilterStore()
        let viewModel = makeViewModel(service: service, store: store)

        await viewModel.suggestAnother()
        #expect(viewModel.movie?.id == 1)

        let filters = DiscoverFilters(genreIDs: [28], minRating: 7)
        await viewModel.applyFilters(filters)

        #expect(store.storedFilters == filters)
        #expect(viewModel.filters == filters)
        #expect(service.requestedFilters.last == filters)
        // Görülenler sıfırlandığı için aynı film tekrar gelebilir.
        #expect(viewModel.movie?.id == 1)
    }

    @Test("Saved filters are loaded on init")
    func savedFiltersLoaded() {
        let store = MockTonightFilterStore()
        store.storedFilters = DiscoverFilters(language: .japanese)

        let viewModel = makeViewModel(service: MockTonightService(), store: store)

        #expect(viewModel.filters.language == .japanese)
    }

    @Test("No results shows the empty state")
    func noResults() async {
        let service = MockTonightService()
        service.pages[1] = TrendingMoviesResponse(page: 1, results: [], totalPages: 0, totalResults: 0)

        let viewModel = makeViewModel(service: service)
        await viewModel.suggestAnother()

        #expect(viewModel.movie == nil)
        #expect(viewModel.isEmptyResult)
        #expect(viewModel.errorMessage == nil)
    }

    @Test("Marking as watched saves it and suggests a new movie")
    func watchedAdvances() async {
        let service = MockTonightService()
        service.pages[1] = Self.response([Self.movie(1), Self.movie(2)])

        let repository = MockWatchlistRepository()
        let viewModel = makeViewModel(service: service)
        viewModel.configure(watchListRepository: repository)

        await viewModel.suggestAnother()
        #expect(viewModel.movie?.id == 1)
        #expect(viewModel.canPerformActions)

        await viewModel.setWatchStatus(.watched)

        #expect(repository.currentStatus == .watched)
        #expect(viewModel.movie?.id == 2)
    }

    @Test("To Watch and Favorite toggle without changing the movie")
    func plannedAndFavoriteKeepMovie() async {
        let service = MockTonightService()
        service.pages[1] = Self.response([Self.movie(1), Self.movie(2)])

        let repository = MockWatchlistRepository()
        let viewModel = makeViewModel(service: service)
        viewModel.configure(watchListRepository: repository)

        await viewModel.suggestAnother()

        await viewModel.setWatchStatus(.planned)
        #expect(viewModel.watchStatus == .planned)
        #expect(viewModel.movie?.id == 1)

        await viewModel.setWatchStatus(.planned)
        #expect(viewModel.watchStatus == nil)

        viewModel.toggleFavorite()
        #expect(viewModel.isFavorite)
        #expect(viewModel.movie?.id == 1)
    }

    @Test("Service error is shown as an error message")
    func serviceError() async {
        let service = MockTonightService()
        service.error = TestError()

        let viewModel = makeViewModel(service: service)
        await viewModel.suggestAnother()

        #expect(viewModel.movie == nil)
        #expect(viewModel.errorMessage == "Boom")
        #expect(viewModel.isLoading == false)
    }
}
