//
//  WatchlistMovie+Display.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 4.07.2026.
//

import Foundation

extension WatchlistMovie {
    var posterURL: URL? {
        guard let posterPath else {
            return nil
        }
        return URL(
            string: "https://image.tmdb.org/t/p/w500\(posterPath)"
        )
    }

    var ratingText: String {
        String(format: "%.1f", voteAverage)
    }
}
