//
//  MovieServiceProtocol.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 15.06.2026.
//

import Foundation

protocol MovieServiceProtocol {
    func fetchTrendingMovies() async throws -> [Movie]
    func fetchPopularMovies() async throws -> [Movie]
    func fetchTopRatedMovies() async throws -> [Movie]
}
