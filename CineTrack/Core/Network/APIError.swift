//
//  APIError.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 14.06.2026.
//

import Foundation

enum APIError: LocalizedError {
    case invalidURL
    case invalidResponse
    case statusCode(Int)
    case decodingError
    case noInternet
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response"
        case .statusCode(let code):
            return "Invalid status code: \(code)"
        case .decodingError:
            return "Failed to decode response"
        case .noInternet:
            return "No internet connection"
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}
