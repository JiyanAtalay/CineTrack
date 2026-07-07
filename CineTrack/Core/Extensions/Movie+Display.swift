//
//  Movie+Display.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 24.06.2026.
//

import Foundation

extension Movie {
    var ratingText: String {
        String(format: "%.1f", voteAverage)
    }
    
    var releaseYear: String {
        guard let releaseDate else { return "" }
        return String(releaseDate.prefix(4))
    }
}
