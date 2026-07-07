//
//  MockMovieDetailService.swift
//  CineTrackTests
//
//  Created by Mehmet Jiyan Atalay on 6.07.2026.
//

import Foundation
@testable import CineTrack

final class MockMovieDetailService: MovieDetailServiceProtocol {
    var movie: MovieDetailResponse!
    var trailerURL: URL?
    var cast: [Cast] = []
    var similarMovies: [Movie] = []

    func fetchMovieDetail(id: Int) async throws -> MovieDetailResponse {
        movie
    }

    func fetchTrailer(id: Int) async throws -> URL? {
        trailerURL
    }

    func fetchCast(id: Int) async throws -> [Cast] {
        cast
    }

    func fetchSimilarMovies(id: Int) async throws -> [Movie] {
        similarMovies
    }
}
