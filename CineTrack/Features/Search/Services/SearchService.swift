//
//  SearchService.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 27.06.2026.
//

import Foundation

final class SearchService: SearchServiceProtocol {
    
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func searchMovie(query: String, page: Int) async throws -> TrendingMoviesResponse {
        let response = try await networkService.request(
            endpoint: TMDBEndpoint.search(query: query, page: page),
            responseModel: TrendingMoviesResponse.self
        )
        
        return response
    }
}
