//
//  MockMovieService.swift
//  CineTrackTests
//
//  Created by Mehmet Jiyan Atalay on 6.07.2026.
//

@testable import CineTrack

final class MockMovieService: MovieServiceProtocol {
    var trendingMovies: [Movie] = []
    var popularMovies: [Movie] = []
    var topRatedMovies: [Movie] = []

    var error: Error?

    func fetchTrendingMovies() async throws -> [Movie] {
        if let error {
            throw error
        }
        return trendingMovies
    }

    func fetchPopularMovies() async throws -> [Movie] {
        if let error {
            throw error
        }
        return popularMovies
    }

    func fetchTopRatedMovies() async throws -> [Movie] {
        if let error {
            throw error
        }
        return topRatedMovies
    }
}
