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

    @Test("Director name is stored and not overwritten by nil")
    @MainActor
    func directorNamePersisted() throws {
        let container = try ModelContainer(for: WatchlistMovie.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))

        let repository = WatchlistRepository(context: container.mainContext)

        let movie = MovieDetailResponse(
            id: 1,
            title: "Inception",
            overview: "",
            posterPath: nil,
            backdropPath: nil,
            releaseDate: nil,
            voteAverage: 8.8,
            runtime: 148,
            genres: []
        )

        repository.setStatus(.watched, for: movie, directorName: "Christopher Nolan")
        #expect(repository.fetchWatched().first?.directorName == "Christopher Nolan")

        repository.setFavorite(true, for: movie, directorName: nil)
        #expect(repository.fetchWatched().first?.directorName == "Christopher Nolan")

        repository.setStatus(.planned, for: movie, directorName: nil)
        #expect(repository.fetchAll().first?.directorName == "Christopher Nolan")
    }

    @Test("Favorite-only movie stores director name")
    @MainActor
    func favoriteStoresDirectorName() throws {
        let container = try ModelContainer(for: WatchlistMovie.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))

        let repository = WatchlistRepository(context: container.mainContext)

        let movie = MovieDetailResponse(
            id: 2,
            title: "Dune",
            overview: "",
            posterPath: nil,
            backdropPath: nil,
            releaseDate: nil,
            voteAverage: 8,
            runtime: 155,
            genres: []
        )

        repository.setFavorite(true, for: movie, directorName: "Denis Villeneuve")
        #expect(repository.fetchFavorites().first?.directorName == "Denis Villeneuve")
    }
}
