//
//  WatchlistRepositoryTests.swift
//  CineTrackTests
//
//  Created by Mehmet Jiyan Atalay on 6.07.2026.
//

import Testing
import SwiftData
@testable import CineTrack


@Suite("Watchlist Repository")
struct WatchlistRepositoryTests {
    @Test("Movie added to watchlist")
    @MainActor
    func addMovie() throws {
        let container = try ModelContainer(for: WatchlistMovie.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        
        let repository = WatchlistRepository(context: container.mainContext)
        
        let movie = MovieDetailResponse(
            id: 1,
            title: "Batman",
            overview: "",
            posterPath: nil,
            backdropPath: nil,
            releaseDate: nil,
            voteAverage: 8,
            runtime: nil,
            genres: []
        )
        
        repository.add(movie: movie)
        let movies = repository.fetchAll()
        
        #expect(movies.count == 1)
    }
    
    @Test("Movie removed from watchlist")
    @MainActor
    func removeMovie() throws {
        let container = try ModelContainer(for: WatchlistMovie.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        
        let repository = WatchlistRepository(context: container.mainContext)
        
        let movie = MovieDetailResponse(
            id: 1,
            title: "Batman",
            overview: "",
            posterPath: nil,
            backdropPath: nil,
            releaseDate: nil,
            voteAverage: 8,
            runtime: nil,
            genres: []
        )
        
        repository.add(movie: movie)
        
        repository.remove(id: 1)

        #expect(repository.fetchAll().isEmpty)
    }
    
    @Test("Contains returns true")
    @MainActor
    func containsMovie() throws {
        let container = try ModelContainer(for: WatchlistMovie.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        
        let repository = WatchlistRepository(context: container.mainContext)
        
        let movie = MovieDetailResponse(
            id: 1,
            title: "Batman",
            overview: "",
            posterPath: nil,
            backdropPath: nil,
            releaseDate: nil,
            voteAverage: 8,
            runtime: nil,
            genres: []
        )
        
        repository.add(movie: movie)

        #expect(repository.contains(id: 1))
    }
}
