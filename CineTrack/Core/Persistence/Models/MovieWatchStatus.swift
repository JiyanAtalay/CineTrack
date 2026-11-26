//
//  MovieWatchStatus.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 19.11.2026.
//

import Foundation

enum MovieWatchStatus: String, CaseIterable, Identifiable {
    case planned
    case watched

    var id: String {
        rawValue
    }

    var title: String {
        switch self {
        case .planned:
            return "To Watch"
        case .watched:
            return "Watched"
        }
    }
}
