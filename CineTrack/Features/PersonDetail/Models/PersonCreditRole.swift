//
//  PersonCreditRole.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 25.11.2026.
//

import Foundation

/// Kişi sayfasına nereden gelindiğini belirtir; hangi filmlerin listeleneceğini seçer.
enum PersonCreditRole: Hashable, Sendable {
    case acting
    case directing

    var title: String {
        switch self {
        case .acting: "Acting"
        case .directing: "Directing"
        }
    }
}
