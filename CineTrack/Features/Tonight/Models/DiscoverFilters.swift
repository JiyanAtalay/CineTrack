//
//  DiscoverFilters.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 26.11.2026.
//

import Foundation

struct DiscoverFilters: Codable, Equatable, Hashable, Sendable {
    var genreIDs: Set<Int> = []
    var fromYear: Int?
    var toYear: Int?
    /// 0 = filtre yok.
    var minRating: Double = 0
    var maxRuntime: RuntimeOption = .any
    var language: OriginalLanguage?

    static let none = DiscoverFilters()

    /// Filtre olmasa bile obskür / puansız filmlerin gelmemesi için gizli taban eşik.
    static let minimumVoteCount = 200
    static let minimumYear = 1950

    static var currentYear: Int {
        Calendar.current.component(.year, from: .now)
    }

    var isEmpty: Bool {
        activeCount == 0
    }

    var activeCount: Int {
        var count = 0
        if !genreIDs.isEmpty { count += 1 }
        if fromYear != nil || toYear != nil { count += 1 }
        if minRating > 0 { count += 1 }
        if maxRuntime != .any { count += 1 }
        if language != nil { count += 1 }
        return count
    }

    /// `page` ve `language` hariç discover query parametreleri.
    var queryItems: [URLQueryItem] {
        var items: [URLQueryItem] = [
            URLQueryItem(name: "sort_by", value: "popularity.desc"),
            URLQueryItem(name: "include_adult", value: "false"),
            URLQueryItem(name: "vote_count.gte", value: "\(Self.minimumVoteCount)")
        ]

        if !genreIDs.isEmpty {
            // "|" = VEYA
            let value = genreIDs.sorted().map(String.init).joined(separator: "|")
            items.append(URLQueryItem(name: "with_genres", value: value))
        }

        if let fromYear {
            items.append(URLQueryItem(name: "primary_release_date.gte", value: "\(fromYear)-01-01"))
        }

        if let toYear {
            items.append(URLQueryItem(name: "primary_release_date.lte", value: "\(toYear)-12-31"))
        }

        if minRating > 0 {
            items.append(URLQueryItem(name: "vote_average.gte", value: String(format: "%.1f", minRating)))
        }

        if let maxMinutes = maxRuntime.maxMinutes {
            items.append(URLQueryItem(name: "with_runtime.lte", value: "\(maxMinutes)"))
        }

        if let language {
            items.append(URLQueryItem(name: "with_original_language", value: language.rawValue))
        }

        return items
    }
}
