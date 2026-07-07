//
//  CreditsResponse.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 3.07.2026.
//

import Foundation

struct CreditsResponse: Decodable, Sendable {
    let cast: [Cast]
}
