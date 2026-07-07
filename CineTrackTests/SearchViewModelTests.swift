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

    @Test
    @MainActor
    func searchReturnsMovies() async throws {
        let service = MockSearchService()
        
        service.response = TrendingMoviesResponse(page: 1, results: [Movie(id: 1, title: "Batman", overview: "", posterPath: nil, backdropPath: nil, releaseDate: nil, voteAverage: 8, genreIDs: [], popularity: 8)], totalPages: 5, totalResults: 100)
        
        let viewModel = SearchViewModel(searchService: service)
        
        viewModel.query = "Batman"
        await viewModel.search()
        
        #expect(viewModel.movies.count == 1)
        
        #expect(viewModel.movies.first?.title == "Batman")
    }
    
    @Test("Empty query clears movies")
    @MainActor
    func emptyQueryClearsMovies() async {
        let service = MockSearchService()

        let viewModel = SearchViewModel(searchService: service)

        viewModel.query = ""
        await viewModel.search()

        #expect(viewModel.movies.isEmpty)
    }

}

final class MockSearchService: SearchServiceProtocol {
    var response: TrendingMoviesResponse!
    
    func searchMovie(query: String, page: Int) async throws -> CineTrack.TrendingMoviesResponse {
        response
    }
}
