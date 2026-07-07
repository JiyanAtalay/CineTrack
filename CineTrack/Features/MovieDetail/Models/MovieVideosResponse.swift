//
//  MovieVideosResponse.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 3.07.2026.
//

import Foundation

struct MovieVideosResponse: Decodable, Sendable {
    let results: [MovieVideo]
}
