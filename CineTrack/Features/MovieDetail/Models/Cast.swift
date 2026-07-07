//
//  Cast.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 3.07.2026.
//

import Foundation

struct Cast: Identifiable, Decodable, Sendable {
    let id: Int
    let name: String
    let character: String
    let profilePath: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case character
        case profilePath = "profile_path"
    }
}
