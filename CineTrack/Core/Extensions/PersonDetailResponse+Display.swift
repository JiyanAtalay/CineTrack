//
//  PersonDetailResponse+Display.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 25.11.2026.
//

import Foundation

extension PersonDetailResponse {
    var profileURL: URL? {
        guard let profilePath else {
            return nil
        }
        return URL(string: "https://image.tmdb.org/t/p/w300\(profilePath)")
    }

    /// Örn. "Born Jul 30, 1970 (55)" ya da "Jul 30, 1970 – Mar 1, 2020 (49)"
    var lifeSpanText: String? {
        guard let birthday, !birthday.isEmpty else {
            return nil
        }

        let endDate = deathday.flatMap(Self.parseDate) ?? Date()
        let ageText = Self.parseDate(birthday)
            .flatMap { Calendar.current.dateComponents([.year], from: $0, to: endDate).year }
            .map { " (\($0))" } ?? ""

        if let deathday, !deathday.isEmpty {
            return "\(birthday.formattedDate) – \(deathday.formattedDate)\(ageText)"
        }

        return "Born \(birthday.formattedDate)\(ageText)"
    }

    var placeOfBirthText: String? {
        guard let placeOfBirth, !placeOfBirth.isEmpty else {
            return nil
        }
        return placeOfBirth
    }

    private static func parseDate(_ string: String) -> Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: string)
    }
}
