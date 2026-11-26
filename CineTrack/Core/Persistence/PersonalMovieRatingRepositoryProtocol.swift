//
//  PersonalMovieRatingRepositoryProtocol.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 17.11.2026.
//

import Foundation

@MainActor
protocol PersonalMovieRatingRepositoryProtocol {
    func fetch(movieID: Int) throws -> PersonalMovieRating?
    func save(movie: MovieDetailResponse, rating: Int, reviewText: String?) throws
    func delete(movieID: Int) throws
    func fetchAll() throws -> [PersonalMovieRating]
}
