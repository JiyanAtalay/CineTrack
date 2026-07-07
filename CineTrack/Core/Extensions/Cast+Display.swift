//
//  Cast+Display.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 3.07.2026.
//

import Foundation

extension Cast {
    var profileURL: URL? {
        guard let profilePath else {
            return nil
        }
        return URL(
            string: "https://image.tmdb.org/t/p/w300\(profilePath)"
        )
    }
}
