//
//  PersonalMovieRatingRepository.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 17.11.2026.
//

import Foundation
import SwiftData

@MainActor
final class PersonalMovieRatingRepository: PersonalMovieRatingRepositoryProtocol {
    private let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    func fetch(movieID: Int) throws -> PersonalMovieRating? {
        let descriptor = FetchDescriptor<PersonalMovieRating>(
            predicate: #Predicate{
                $0.movieID == movieID
            }
        )
        
        return try context.fetch(descriptor).first
    }
    
    func save(movie: MovieDetailResponse, rating: Int, reviewText: String?) throws {
        guard (1...5).contains(rating) else {
            return
        }
        
        let trimmedReview = reviewText?.trimmingCharacters(in: .whitespacesAndNewlines)
        let normalizedReview = trimmedReview?.isEmpty == false ? trimmedReview : nil
        
        if let existingRating = try fetch(movieID: movie.id) {
            
            existingRating.movieTitle = movie.title
            existingRating.posterPath = movie.posterPath
            existingRating.rating = rating
            existingRating.reviewText = normalizedReview
            existingRating.updatedAt = .now
            
        } else {
            
            let newRating = PersonalMovieRating(
                movieID: movie.id,
                movieTitle: movie.title,
                posterPath: movie.posterPath,
                rating: rating,
                reviewText: normalizedReview
            )
            
            context.insert(newRating)
        }
        try context.save()
    }
    
    func delete(movieID: Int) throws {
        guard let rating = try fetch(movieID: movieID) else {
            return
        }
        
        context.delete(rating)
        try context.save()
    }
    
    func fetchAll() throws -> [PersonalMovieRating] {
        let descriptor = FetchDescriptor<PersonalMovieRating>(
            sortBy: [SortDescriptor(\.updatedAt, order: .reverse)]
        )
        return try context.fetch(descriptor)
    }
}
