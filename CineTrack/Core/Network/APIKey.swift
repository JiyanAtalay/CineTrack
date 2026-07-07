//
//  APIKey.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 14.06.2026.
//

import Foundation

enum APIKey {
    static var tmdbToken: String {
        guard let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
              let dictionary = NSDictionary(contentsOfFile: path),
              let token = dictionary["TMDB_API_KEY"] as? String
        else {
            fatalError("TMDB API Key not found")
        }
        return token
    }
}
