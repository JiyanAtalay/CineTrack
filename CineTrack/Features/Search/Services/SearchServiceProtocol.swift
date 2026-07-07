//
//  SearchServiceProtocol.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 27.06.2026.
//

import Foundation

protocol SearchServiceProtocol {
    func searchMovie(query: String, page: Int) async throws -> TrendingMoviesResponse
}
