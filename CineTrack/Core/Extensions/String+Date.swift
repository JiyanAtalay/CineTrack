//
//  String+Date.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 4.07.2026.
//

import Foundation

extension String {
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"

        guard let date = formatter.date(from: self) else {
            return self
        }

        formatter.dateStyle = .medium

        return formatter.string(from: date)
    }
}
