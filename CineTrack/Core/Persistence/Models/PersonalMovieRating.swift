//
//  PersonalMovieRating.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 17.11.2026.
//

import Foundation
import SwiftData

@Model
final class PersonalMovieRating {
    @Attribute(.unique)
    var movieID: Int
    var movieTitle: String
    var posterPath: String?
    
    var rating: Int
    var reviewText: String?
    
    var createdAt: Date
    var updatedAt: Date
    
    init(movieID: Int, movieTitle: String, posterPath: String?, rating: Int, reviewText: String?) {
        self.movieID = movieID
        self.movieTitle = movieTitle
        self.posterPath = posterPath
        self.rating = rating
        self.reviewText = reviewText
        self.createdAt = .now
        self.updatedAt = .now
    }
}
