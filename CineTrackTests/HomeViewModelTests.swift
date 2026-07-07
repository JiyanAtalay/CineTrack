//
//  HomeViewModelTests.swift
//  CineTrackTests
//
//  Created by Mehmet Jiyan Atalay on 6.07.2026.
//

import Testing
@testable import CineTrack

@Suite("HomeViewModel Tests")
struct HomeViewModelTests {
    @Test
    @MainActor
    func fetchHomeDataSuccess() async {
        let service = MockMovieService()
        
        service.trendingMovies = [
            Movie(
                id: 1,
                title: "Batman",
                overview: "",
                posterPath: nil,
                backdropPath: nil,
                releaseDate: nil,
                voteAverage: 8,
                genreIDs: [],
                popularity: 100
            )
        ]
        
        service.popularMovies = service.trendingMovies
        service.topRatedMovies = service.trendingMovies
        
        let viewModel = HomeViewModel(movieService: service)
        
        await viewModel.fetchHomeData()
        
        #expect(viewModel.trendingMovies.count == 1)
        #expect(viewModel.populerMovies.count == 1)
        #expect(viewModel.topRatedMovies.count == 1)
        #expect(viewModel.isLoading == false)
        #expect(viewModel.errorMessage == nil)
    }

}
