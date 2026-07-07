//
//  TrendingMoviesResponse.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 15.06.2026.
//

import Foundation

struct TrendingMoviesResponse: Decodable {
    let page: Int
    let results: [Movie]
    let totalPages: Int
    let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
