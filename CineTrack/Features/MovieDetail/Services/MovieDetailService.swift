//
//  MovieDetailService.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 2.07.2026.
//

import Foundation

final class MovieDetailService: MovieDetailServiceProtocol {
    
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func fetchMovieDetail(id: Int) async throws -> MovieDetailResponse {
        try await networkService.request(endpoint: TMDBEndpoint.movieDetail(id: id), responseModel: MovieDetailResponse.self)
    }
    
    func fetchTrailer(id: Int) async throws -> URL? {
        let response = try await networkService.request(endpoint: TMDBEndpoint.movieVideos(id: id), responseModel: MovieVideosResponse.self)
        
        guard let trailer = response.results.first(where: {
            $0.site == "YouTube" && $0.type == "Trailer"
        }) else {
            return nil
        }
        
        return URL(string: "https://www.youtube.com/watch?v=\(trailer.key)")
    }
    
    func fetchCredits(id: Int) async throws -> CreditsResponse {
        try await networkService.request(
            endpoint: TMDBEndpoint.movieCredits(id: id),
            responseModel: CreditsResponse.self
        )
    }
    
    func fetchSimilarMovies(id: Int) async throws -> [Movie] {
        let response = try await networkService.request(
            endpoint: TMDBEndpoint.similarMovies(id: id),
            responseModel: TrendingMoviesResponse.self
        )
        
        return response.results
    }
}
