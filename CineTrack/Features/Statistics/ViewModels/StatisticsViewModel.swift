//
//  StatisticsViewModel.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 24.11.2026.
//

import Foundation
import Observation
import SwiftData

@MainActor
@Observable
final class StatisticsViewModel {
    
    // MARK: - Summary Stats
    
    private(set) var totalWatchedCount: Int = 0
    private(set) var totalWatchTimeMinutes: Int = 0
    private(set) var averageRating: Double = 0.0
    private(set) var totalRatedCount: Int = 0
    
    // MARK: - Chart Data
    
    private(set) var ratingDistribution: [RatingBucket] = []
    private(set) var genreDistribution: [GenreBucket] = []
    private(set) var directorDistribution: [DirectorBucket] = []

    static let topDirectorLimit = 5

    // MARK: - Formatted
    
    var totalWatchTimeFormatted: String {
        let hours = totalWatchTimeMinutes / 60
        let minutes = totalWatchTimeMinutes % 60
        if hours == 0 {
            return "\(minutes)m"
        }
        return "\(hours)h \(minutes)m"
    }
    
    var averageRatingFormatted: String {
        totalRatedCount == 0 ? "—" : String(format: "%.1f", averageRating)
    }
    
    // MARK: - Load
    
    func load(context: ModelContext) {
        loadWatchedStats(context: context)
        loadRatingStats(context: context)
    }
    
    private func loadWatchedStats(context: ModelContext) {
        let watchedRaw = MovieWatchStatus.watched.rawValue
        let descriptor = FetchDescriptor<WatchlistMovie>(
            predicate: #Predicate { $0.watchStatus == watchedRaw }
        )
        
        let movies = (try? context.fetch(descriptor)) ?? []
        
        totalWatchedCount = movies.count
        totalWatchTimeMinutes = movies.compactMap(\.runtime).reduce(0, +)
        
        // Genre distribution
        var genreCounts: [String: Int] = [:]
        for movie in movies {
            for genre in movie.genreNames {
                genreCounts[genre, default: 0] += 1
            }
        }
        genreDistribution = genreCounts
            .map { GenreBucket(genre: $0.key, count: $0.value) }
            .sorted { $0.count > $1.count }

        // Director distribution (top 5, movies without director info are skipped)
        var directorCounts: [String: Int] = [:]
        for movie in movies {
            guard let director = movie.directorName, !director.isEmpty else { continue }
            directorCounts[director, default: 0] += 1
        }
        directorDistribution = Array(
            directorCounts
                .map { DirectorBucket(name: $0.key, count: $0.value) }
                .sorted { $0.count != $1.count ? $0.count > $1.count : $0.name < $1.name }
                .prefix(Self.topDirectorLimit)
        )
    }
    
    private func loadRatingStats(context: ModelContext) {
        let descriptor = FetchDescriptor<PersonalMovieRating>()
        let ratings = (try? context.fetch(descriptor)) ?? []
        
        totalRatedCount = ratings.count
        
        if ratings.isEmpty {
            averageRating = 0
            ratingDistribution = (1...5).map { RatingBucket(rating: $0, count: 0) }
            return
        }
        
        let sum = ratings.reduce(0) { $0 + $1.rating }
        averageRating = Double(sum) / Double(ratings.count)
        
        var buckets: [Int: Int] = [:]
        for r in 1...5 { buckets[r] = 0 }
        for rating in ratings {
            buckets[rating.rating, default: 0] += 1
        }
        ratingDistribution = (1...5).map { RatingBucket(rating: $0, count: buckets[$0] ?? 0) }
    }
}

// MARK: - Chart Models

struct RatingBucket: Identifiable {
    let rating: Int
    let count: Int
    var id: Int { rating }
    
    var label: String { "\(rating)★" }
}

struct GenreBucket: Identifiable {
    let genre: String
    let count: Int
    var id: String { genre }
}

struct DirectorBucket: Identifiable {
    let name: String
    let count: Int
    var id: String { name }
}
