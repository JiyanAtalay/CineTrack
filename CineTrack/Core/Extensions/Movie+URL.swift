//
//  Movie+URL.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 15.06.2026.
//

import Foundation

extension Movie {
    var posterURL: URL? {
        guard let posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
    }
    
    var backdropURL: URL? {
        guard let backdropPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w780\(backdropPath)")
    }
}
