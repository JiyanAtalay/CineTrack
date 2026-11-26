//
//  PersonMovieCreditsResponse.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 25.11.2026.
//

import Foundation

struct PersonMovieCreditsResponse: Decodable, Sendable {
    let cast: [PersonMovieCredit]
    let crew: [PersonMovieCredit]
}
