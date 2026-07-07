//
//  MovieDetailResponse+Display.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 2.07.2026.
//

import Foundation

extension MovieDetailResponse {
    var posterURL: URL? {
        guard let posterPath else { return nil }

        return URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
    }

    var backdropURL: URL? {
        guard let backdropPath else { return nil }

        return URL(string: "https://image.tmdb.org/t/p/w780\(backdropPath)")
    }

    var ratingText: String {
        String(format: "%.1f", voteAverage)
    }

    var runtimeText: String {
        guard let runtime else { return "-" }

        return "\(runtime) min"
    }

    var releaseYear: String {
        String(releaseDate?.prefix(4) ?? "")
    }
}
