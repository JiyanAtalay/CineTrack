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

    func add(movie: MovieDetailResponse) {
        addedMovie = movie
        containsMovie = true
    }

    func remove(id: Int) {
        removedMovieID = id
        containsMovie = false
    }

    func contains(id: Int) -> Bool {
        containsMovie
    }

    func fetchAll() -> [WatchlistMovie] {
        []
    }
}
