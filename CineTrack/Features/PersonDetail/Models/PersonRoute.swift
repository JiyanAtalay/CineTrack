//
//  PersonRoute.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 25.11.2026.
//

import Foundation

struct PersonRoute: Hashable, Identifiable, Sendable {
    let id: Int
    let name: String
    let role: PersonCreditRole
}
