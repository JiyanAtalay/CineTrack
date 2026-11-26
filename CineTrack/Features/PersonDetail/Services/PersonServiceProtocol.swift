//
//  PersonServiceProtocol.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 25.11.2026.
//

import Foundation

protocol PersonServiceProtocol {
    func fetchPersonDetail(id: Int, language: String) async throws -> PersonDetailResponse
    func fetchMovieCredits(id: Int) async throws -> PersonMovieCreditsResponse
}
