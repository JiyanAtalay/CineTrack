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
    
    var watchStatus: String? = MovieWatchStatus.planned.rawValue
    var isFavorite: Bool = false
    
    var genreNames: [String] = []
    var runtime: Int? = nil
    var directorName: String? = nil
    
    init(id: Int, title: String, posterPath: String?, backdropPath: String?, releaseDate: String?, voteAverage: Double,
         watchStatus: String? = MovieWatchStatus.planned.rawValue, isFavorite: Bool = false,
         genreNames: [String] = [], runtime: Int? = nil, directorName: String? = nil) {
        self.id = id
        self.title = title
        self.posterPath = posterPath
        self.backdropPath = backdropPath
        self.releaseDate = releaseDate
        self.voteAverage = voteAverage
        self.watchStatus = watchStatus
        self.isFavorite = isFavorite
        self.genreNames = genreNames
        self.runtime = runtime
        self.directorName = directorName
    }
    
    var movieWatchStatus: MovieWatchStatus? {
        guard let watchStatus else { return nil }
        return MovieWatchStatus(rawValue: watchStatus)
    }
}
