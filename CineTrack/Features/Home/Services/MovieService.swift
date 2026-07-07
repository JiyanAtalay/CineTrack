//
//  MovieService.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 15.06.2026.
//

import Foundation

final class MovieService: MovieServiceProtocol {
    
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func fetchTrendingMovies() async throws -> [Movie] {
        let response = try await networkService.request(endpoint: TMDBEndpoint.trending, responseModel: TrendingMoviesResponse.self)
        return response.results
    }
    
    func fetchPopularMovies() async throws -> [Movie] {
        let response = try await networkService.request(endpoint: TMDBEndpoint.popular, responseModel: TrendingMoviesResponse.self)
        return response.results
    }
    
    func fetchTopRatedMovies() async throws -> [Movie] {
        let response = try await networkService.request(endpoint: TMDBEndpoint.topRated, responseModel: TrendingMoviesResponse.self)
        return response.results
    }
}
