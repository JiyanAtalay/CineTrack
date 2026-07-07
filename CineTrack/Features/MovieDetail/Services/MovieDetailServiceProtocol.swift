//
//  MovieDetailServiceProtocol.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 2.07.2026.
//

import Foundation

protocol MovieDetailServiceProtocol {
    func fetchMovieDetail(id: Int) async throws -> MovieDetailResponse
    func fetchTrailer(id: Int) async throws -> URL?
    func fetchCast(id: Int) async throws -> [Cast]
    func fetchSimilarMovies(id: Int) async throws -> [Movie]
}
