//
//  MovieVideo.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 3.07.2026.
//

import Foundation

struct MovieVideo: Decodable, Identifiable, Sendable {
    let id: String
    let key: String
    let name: String
    let site: String
    let type: String
}
