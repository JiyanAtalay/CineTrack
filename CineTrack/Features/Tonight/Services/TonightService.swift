//
//  TonightService.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 26.11.2026.
//

import Foundation

final class TonightService: TonightServiceProtocol {

    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }

    func fetchGenres() async throws -> [Genre] {
        let response = try await networkService.request(
            endpoint: TMDBEndpoint.movieGenres,
            responseModel: GenreListResponse.self
        )
        return response.genres
    }

    func discoverMovies(filters: DiscoverFilters, page: Int) async throws -> TrendingMoviesResponse {
        try await networkService.request(
            endpoint: TMDBEndpoint.discover(filters: filters, page: page),
            responseModel: TrendingMoviesResponse.self
        )
    }
}
