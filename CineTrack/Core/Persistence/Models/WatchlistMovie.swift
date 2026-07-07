//
//  WatchlistMovie.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 4.07.2026.
//

import Foundation
import SwiftData

@Model
final class WatchlistMovie {
    @Attribute(.unique)
    var id: Int
    var title: String
    var posterPath: String?
    var backdropPath: String?
    var releaseDate: String?
    var voteAverage: Double
    
    init(id: Int, title: String, posterPath: String?, backdropPath: String?, releaseDate: String?, voteAverage: Double) {
        self.id = id
        self.title = title
        self.posterPath = posterPath
        self.backdropPath = backdropPath
        self.releaseDate = releaseDate
        self.voteAverage = voteAverage
    }
}
