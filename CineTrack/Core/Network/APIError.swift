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
            return "The request couldn't be created."
        case .invalidResponse:
            return "The server sent an unexpected response. Please try again."
        case .statusCode(let code):
            switch code {
            case 401, 403:
                return "The movie service rejected the request (\(code))."
            case 404:
                return "We couldn't find what you were looking for."
            case 429:
                return "Too many requests. Please wait a moment and try again."
            case 500...599:
                return "The movie service is having trouble right now. Please try again later."
            default:
                return "Something went wrong (error \(code)). Please try again."
            }
        case .decodingError:
            return "We received data we couldn't read. Please try again later."
        case .noInternet:
            return "You're offline. Check your internet connection and try again."
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}
