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
        setStatus(.planned, for: movie, directorName: nil)
    }

    func remove(id: Int) {
        guard let savedMovie = findMovie(id: id) else {
            return
        }

        savedMovie.watchStatus = nil
        deleteIfUnused(savedMovie)

        saveContext()
    }

    func contains(id: Int) -> Bool {
        status(for: id) != nil
    }

    func setStatus(
        _ status: MovieWatchStatus?,
        for movie: MovieDetailResponse,
        directorName: String?
    ) {
        let savedMovie = findOrCreate(movie: movie)

        savedMovie.watchStatus = status?.rawValue
        savedMovie.genreNames = movie.genres.map(\.name)
        savedMovie.runtime = movie.runtime
        updateDirectorName(directorName, on: savedMovie)

        deleteIfUnused(savedMovie)
        saveContext()
    }

    func status(for id: Int) -> MovieWatchStatus? {
        findMovie(id: id)?.movieWatchStatus
    }

    func fetch(status: MovieWatchStatus) -> [WatchlistMovie] {
        let rawValue = status.rawValue

        let descriptor = FetchDescriptor<WatchlistMovie>(
            predicate: #Predicate {
                $0.watchStatus == rawValue
            },
            sortBy: [
                SortDescriptor(\.title)
            ]
        )

        return (try? context.fetch(descriptor)) ?? []
    }

    func setFavorite(
        _ isFavorite: Bool,
        for movie: MovieDetailResponse,
        directorName: String?
    ) {
        if let savedMovie = findMovie(id: movie.id) {
            savedMovie.isFavorite = isFavorite
            updateDirectorName(directorName, on: savedMovie)

            deleteIfUnused(savedMovie)
            saveContext()

        } else if isFavorite {
            let savedMovie = createMovie(
                from: movie,
                watchStatus: nil,
                isFavorite: true,
                directorName: directorName
            )

            context.insert(savedMovie)
            saveContext()
        }
    }

    func isFavorite(id: Int) -> Bool {
        findMovie(id: id)?.isFavorite ?? false
    }

    func fetchFavorites() -> [WatchlistMovie] {
        let descriptor = FetchDescriptor<WatchlistMovie>(
            predicate: #Predicate {
                $0.isFavorite == true
            },
            sortBy: [
                SortDescriptor(\.title)
            ]
        )

        return (try? context.fetch(descriptor)) ?? []
    }

    func fetchAll() -> [WatchlistMovie] {
        fetch(status: .planned)
    }
    
    func fetchWatched() -> [WatchlistMovie] {
        fetch(status: .watched)
    }

    private func findMovie(id: Int) -> WatchlistMovie? {
        let descriptor = FetchDescriptor<WatchlistMovie>(
            predicate: #Predicate {
                $0.id == id
            }
        )

        return try? context.fetch(descriptor).first
    }

    private func findOrCreate(
        movie: MovieDetailResponse
    ) -> WatchlistMovie {

        if let existingMovie = findMovie(id: movie.id) {
            return existingMovie
        }

        let newMovie = createMovie(
            from: movie,
            watchStatus: nil,
            isFavorite: false,
            directorName: nil
        )

        context.insert(newMovie)

        return newMovie
    }

    private func createMovie(
        from movie: MovieDetailResponse,
        watchStatus: String?,
        isFavorite: Bool,
        directorName: String?
    ) -> WatchlistMovie {

        WatchlistMovie(
            id: movie.id,
            title: movie.title,
            posterPath: movie.posterPath,
            backdropPath: movie.backdropPath,
            releaseDate: movie.releaseDate,
            voteAverage: movie.voteAverage,
            watchStatus: watchStatus,
            isFavorite: isFavorite,
            genreNames: movie.genres.map(\.name),
            runtime: movie.runtime,
            directorName: directorName
        )
    }

    /// Only overwrites when a value is provided, so a failed/missing credits
    /// fetch never wipes a previously stored director.
    private func updateDirectorName(_ directorName: String?, on movie: WatchlistMovie) {
        guard let directorName, !directorName.isEmpty else { return }
        movie.directorName = directorName
    }

    private func deleteIfUnused(_ movie: WatchlistMovie) {
        if movie.watchStatus == nil && !movie.isFavorite {
            context.delete(movie)
        }
    }

    private func saveContext() {
        try? context.save()
    }
}
