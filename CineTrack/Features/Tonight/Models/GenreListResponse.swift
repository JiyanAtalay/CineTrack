//
//  GenreListResponse.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 26.11.2026.
//

import Foundation

struct GenreListResponse: Decodable, Sendable {
    let genres: [Genre]
}
