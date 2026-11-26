//
//  MockWatchlistRepository.swift
//  CineTrackTests
//
//  Created by Mehmet Jiyan Atalay on 6.07.2026.
//

import Foundation
@testable import CineTrack

final class MockWatchlistRepository: WatchlistRepositoryProtocol {
    var containsMovie = false

    var addedMovie: MovieDetailResponse?
    var removedMovieID: Int?

    var currentStatus: MovieWatchStatus?
    var currentIsFavorite = false
    var lastDirectorName: String?

    func add(movie: MovieDetailResponse) {
        addedMovie = movie
        containsMovie = true
        currentStatus = .planned
    }

    func remove(id: Int) {
        removedMovieID = id
        containsMovie = false
        currentStatus = nil
    }

    func contains(id: Int) -> Bool {
        containsMovie
    }

    func setStatus(_ status: MovieWatchStatus?, for movie: MovieDetailResponse, directorName: String?) {
        currentStatus = status
        containsMovie = status != nil
        lastDirectorName = directorName
    }

    func status(for id: Int) -> MovieWatchStatus? { currentStatus }
    func fetch(status: MovieWatchStatus) -> [WatchlistMovie] { [] }

    func setFavorite(_ isFavorite: Bool, for movie: MovieDetailResponse, directorName: String?) {
        currentIsFavorite = isFavorite
        lastDirectorName = directorName
    }

    func isFavorite(id: Int) -> Bool { currentIsFavorite }
    func fetchFavorites() -> [WatchlistMovie] { [] }

    func fetchAll() -> [WatchlistMovie] {
        []
    }

    func fetchWatched() -> [WatchlistMovie] {
        []
    }
}
