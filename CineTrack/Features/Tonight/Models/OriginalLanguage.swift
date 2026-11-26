//
//  OriginalLanguage.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 26.11.2026.
//

import Foundation

/// ISO 639-1 kodları; TMDB `with_original_language` parametresine gider.
enum OriginalLanguage: String, Codable, CaseIterable, Identifiable, Sendable {
    case english = "en"
    case turkish = "tr"
    case korean = "ko"
    case japanese = "ja"
    case french = "fr"
    case spanish = "es"
    case italian = "it"
    case german = "de"
    case hindi = "hi"

    var id: String { rawValue }

    var title: String {
        switch self {
        case .english: return "English"
        case .turkish: return "Turkish"
        case .korean: return "Korean"
        case .japanese: return "Japanese"
        case .french: return "French"
        case .spanish: return "Spanish"
        case .italian: return "Italian"
        case .german: return "German"
        case .hindi: return "Hindi"
        }
    }
}
