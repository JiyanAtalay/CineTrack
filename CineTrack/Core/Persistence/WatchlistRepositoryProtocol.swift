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
    func fetchAll() -> [WatchlistMovie]
}
