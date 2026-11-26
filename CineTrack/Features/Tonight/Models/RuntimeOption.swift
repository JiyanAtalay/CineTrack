//
//  RuntimeOption.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 26.11.2026.
//

import Foundation

enum RuntimeOption: String, Codable, CaseIterable, Identifiable, Sendable {
    case any
    case under90
    case under120
    case under150

    var id: String { rawValue }

    var maxMinutes: Int? {
        switch self {
        case .any: return nil
        case .under90: return 90
        case .under120: return 120
        case .under150: return 150
        }
    }

    var title: String {
        switch self {
        case .any: return "Any"
        case .under90: return "< 90m"
        case .under120: return "< 120m"
        case .under150: return "< 150m"
        }
    }
}
