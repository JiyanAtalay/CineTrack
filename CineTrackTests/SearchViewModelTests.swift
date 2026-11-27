//
//  SearchViewModelTests.swift
//  CineTrackTests
//
//  Created by Mehmet Jiyan Atalay on 6.07.2026.
//

import Testing
@testable import CineTrack

@Suite("SearchViewModel Tests")
struct SearchViewModelTests {

    private static func movie(id: Int, title: String = "Batman") -> Movie {
        Movie(id: id, title: title, overview: "", posterPath: nil, backdropPath: nil, releaseDate: nil, voteAverage: 8, genreIDs: [], popularity: 8)
    }

    @Test
    @MainActor
    func searchReturnsMovies() async throws {
        let service = MockSearchService()

        service.response = TrendingMoviesResponse(page: 1, results: [Self.movie(id: 1)], totalPages: 5, totalResults: 100)

        let viewModel = SearchViewModel(searchService: service)

        viewModel.query = "Batman"
        await viewModel.search()

        #expect(viewModel.movies.count == 1)
        #expect(viewModel.movies.first?.title == "Batman")
        #expect(viewModel.hasSearched)
        #expect(viewModel.errorMessage == nil)
    }

    @Test("Empty query clears movies")
    @MainActor
    func emptyQueryClearsMovies() async {
        let service = MockSearchService()

        let viewModel = SearchViewModel(searchService: service)

        viewModel.query = ""
        await viewModel.search()

        #expect(viewModel.movies.isEmpty)
        #expect(viewModel.hasSearched == false)
    }

    @Test("No results marks the search as completed")
    @MainActor
    func noResults() async {
        let service = MockSearchService()
        service.response = TrendingMoviesResponse(page: 1, results: [], totalPages: 1, totalResults: 0)

        let viewModel = SearchViewModel(searchService: service)
        viewModel.query = "zzzz"
        await viewModel.search()

        #expect(viewModel.movies.isEmpty)
        #expect(viewModel.hasSearched)
        #expect(viewModel.errorMessage == nil)
    }

    @Test("Service error sets errorMessage, next search clears it")
    @MainActor
    func searchErrorThenRecover() async {
        let service = MockSearchService()
        service.error = APIError.noInternet

        let viewModel = SearchViewModel(searchService: service)
        viewModel.query = "Batman"
        await viewModel.search()

        #expect(viewModel.errorMessage == APIError.noInternet.errorDescription)
        #expect(viewModel.movies.isEmpty)
        #expect(viewModel.isLoading == false)

        service.error = nil
        service.response = TrendingMoviesResponse(page: 1, results: [Self.movie(id: 1)], totalPages: 1, totalResults: 1)
        await viewModel.search()

        #expect(viewModel.errorMessage == nil)
        #expect(viewModel.movies.count == 1)
    }

    @Test("Next page requests the following page and appends results")
    @MainActor
    func loadsNextPage() async {
        let service = MockSearchService()
        service.response = TrendingMoviesResponse(page: 1, results: [Self.movie(id: 1)], totalPages: 3, totalResults: 3)

        let viewModel = SearchViewModel(searchService: service)
        viewModel.query = "Batman"
        await viewModel.search()

        service.response = TrendingMoviesResponse(page: 2, results: [Self.movie(id: 2)], totalPages: 3, totalResults: 3)
        await viewModel.loadNextPageIfNeeded(currentMovie: Self.movie(id: 1))

        #expect(service.requestedPages == [1, 2])
        #expect(viewModel.movies.map(\.id) == [1, 2])
        #expect(viewModel.canLoadMore)
    }

    @Test("Next page error keeps existing results")
    @MainActor
    func nextPageErrorKeepsResults() async {
        let service = MockSearchService()
        service.response = TrendingMoviesResponse(page: 1, results: [Self.movie(id: 1)], totalPages: 2, totalResults: 2)

        let viewModel = SearchViewModel(searchService: service)
        viewModel.query = "Batman"
        await viewModel.search()

        service.error = APIError.statusCode(500)
        await viewModel.loadNextPage()

        #expect(viewModel.movies.map(\.id) == [1])
        #expect(viewModel.errorMessage == nil)
        #expect(viewModel.nextPageErrorMessage != nil)
        #expect(viewModel.canLoadMore)
    }

}

final class MockSearchService: SearchServiceProtocol {
    var response: TrendingMoviesResponse!
    var error: Error?
    private(set) var requestedPages: [Int] = []

    func searchMovie(query: String, page: Int) async throws -> CineTrack.TrendingMoviesResponse {
        requestedPages.append(page)
        if let error {
            throw error
        }
        return response
    }
}
