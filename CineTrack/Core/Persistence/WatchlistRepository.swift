//
//  WatchlistRepository.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 4.07.2026.
//

import Foundation
import SwiftData

@MainActor
final class WatchlistRepository: WatchlistRepositoryProtocol {
    private let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    func add(movie: MovieDetailResponse) {
        guard !contains(id: movie.id) else { return }
        
        let watchlistMovie = WatchlistMovie(id: movie.id, title: movie.title, posterPath: movie.posterPath, backdropPath: movie.backdropPath, releaseDate: movie.releaseDate, voteAverage: movie.voteAverage)
        
        context.insert(watchlistMovie)
        
        try? context.save()
    }
    
    func remove(id: Int) {
        let descriptor = FetchDescriptor<WatchlistMovie>(
            predicate: #Predicate{
                $0.id == id
            }
        )
        
        if let movie = try? context.fetch(descriptor).first {
            context.delete(movie)
            
            try? context.save()
        }
    }
    
    func contains(id: Int) -> Bool {
        let descriptor = FetchDescriptor<WatchlistMovie>(
            predicate: #Predicate{
                $0.id == id
            }
        )
        
        let movies = (try? context.fetch(descriptor)) ?? []
        
        return !movies.isEmpty
    }
    
    func fetchAll() -> [WatchlistMovie] {
        let descriptor = FetchDescriptor<WatchlistMovie>(
            sortBy: [
                SortDescriptor(\.title)
            ]
        )
        
        return (try? context.fetch(descriptor)) ?? []
    }
}
