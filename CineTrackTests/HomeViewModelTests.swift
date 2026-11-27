//
//  HomeViewModelTests.swift
//  CineTrackTests
//
//  Created by Mehmet Jiyan Atalay on 6.07.2026.
//

import Foundation
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
        #expect(viewModel.hasContent)
        #expect(viewModel.hasLoaded)
    }

    @Test("Service error sets errorMessage and retry clears it")
    @MainActor
    func fetchHomeDataErrorThenRetry() async {
        let service = MockMovieService()
        service.error = APIError.noInternet

        let viewModel = HomeViewModel(movieService: service)
        #expect(viewModel.hasLoaded == false)

        await viewModel.fetchHomeData()

        #expect(viewModel.errorMessage == APIError.noInternet.errorDescription)
        #expect(viewModel.hasContent == false)
        #expect(viewModel.hasLoaded)
        #expect(viewModel.isLoading == false)

        service.error = nil
        service.trendingMovies = [
            Movie(id: 1, title: "Batman", overview: "", posterPath: nil, backdropPath: nil,
                  releaseDate: nil, voteAverage: 8, genreIDs: [], popularity: 100)
        ]

        await viewModel.fetchHomeData()

        #expect(viewModel.errorMessage == nil)
        #expect(viewModel.hasContent)
    }

    @Test("Cancellation is not shown as an error")
    @MainActor
    func cancellationIsIgnored() async {
        let service = MockMovieService()
        service.error = APIError.unknown(URLError(.cancelled))

        let viewModel = HomeViewModel(movieService: service)
        await viewModel.fetchHomeData()

        #expect(viewModel.errorMessage == nil)
        #expect(viewModel.hasLoaded == false)
    }

}
