//
//  TMDBEndpoint.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 14.06.2026.
//

import Foundation

enum TMDBEndpoint: Endpoint {
    case trending
    case popular
    case topRated
    case movieDetail(id: Int)
    case search(query: String, page: Int)
    case movieVideos(id: Int)
    case movieCredits(id: Int)
    case similarMovies(id: Int)
    case personDetail(id: Int, language: String)
    case personMovieCredits(id: Int)
    
    var path: String {
        switch self {
        case .trending:
            return "/3/trending/movie/day"
        case .popular:
            return "/3/movie/popular"
        case .topRated:
            return "/3/movie/top_rated"
        case .movieDetail(let id):
            return "/3/movie/\(id)"
        case .search:
            return "/3/search/movie"
        case .movieVideos(let id):
            return "/3/movie/\(id)/videos"
        case .movieCredits(let id):
            return "/3/movie/\(id)/credits"
        case .similarMovies(let id):
            return "/3/movie/\(id)/similar"
        case .personDetail(let id, _):
            return "/3/person/\(id)"
        case .personMovieCredits(let id):
            return "/3/person/\(id)/movie_credits"
        }
    }
    
    var method: HTTPMethod {
        .get
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
            case .trending,
                .popular,
                .movieDetail,
                .topRated,
                .movieVideos,
                .movieCredits,
                .similarMovies,
                .personMovieCredits:
            
            return [URLQueryItem(name: "language", value: "tr-TR")]
        
        case .personDetail(_, let language):
            return [URLQueryItem(name: "language", value: language)]
        
        case .search(query: let query, page: let page):
            return [
                URLQueryItem(name: "query", value: query),
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "language", value: "tr-TR")
            ]
        }
    }
}
