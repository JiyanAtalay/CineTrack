//
//  WatchlistRepositoryProtocol.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 4.07.2026.
//

import Foundation

protocol WatchlistRepositoryProtocol {
    func add(movie: MovieDetailResponse)
    func remove(id: Int)
    func contains(id: Int) -> Bool
    
    func setStatus(_ status: MovieWatchStatus?, for movie: MovieDetailResponse, directorName: String?)
    func status(for id: Int) -> MovieWatchStatus?
    func fetch(status: MovieWatchStatus) -> [WatchlistMovie]
    
    func setFavorite(_ isFavorite: Bool, for movie: MovieDetailResponse, directorName: String?)
    func isFavorite(id: Int) -> Bool
    func fetchFavorites() -> [WatchlistMovie]
    
    func fetchAll() -> [WatchlistMovie]
    func fetchWatched() -> [WatchlistMovie]
}
