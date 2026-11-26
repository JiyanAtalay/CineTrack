//
//  TonightServiceProtocol.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 26.11.2026.
//

import Foundation

protocol TonightServiceProtocol {
    func fetchGenres() async throws -> [Genre]
    func discoverMovies(filters: DiscoverFilters, page: Int) async throws -> TrendingMoviesResponse
}
