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

    @Test("Load movie successfully")
    @MainActor
    func loadMovieSuccess() async {
        let service = MockMovieDetailService()

        service.movie = MovieDetailResponse(
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

        let viewModel = MovieDetailViewModel(service: service)
        await viewModel.loadMovie(id: 1)

        #expect(viewModel.movie?.title == "Batman")
        #expect(viewModel.errorMessage == nil)
        #expect(viewModel.isLoading == false)
    }

    @Test("Toggle watchlist")
    @MainActor
    func toggleWatchlist() {
        let service = MockMovieDetailService()

        service.movie = MovieDetailResponse(
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

        let repository = MockWatchlistRepository()

        let viewModel = MovieDetailViewModel(service: service)

        viewModel.configure(
            watchListRepository: repository
        )

        Task {
            await viewModel.loadMovie(id: 1)

            viewModel.toggleWatchList()

            #expect(repository.addedMovie != nil)
            #expect(viewModel.isInWatchlist)
        }
    }
}
