//
//  Genre.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 2.07.2026.
//

import Foundation

struct Genre: Decodable, Identifiable, Sendable {
    let id: Int
    let name: String
}
