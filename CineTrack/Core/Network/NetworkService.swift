//
//  NetworkService.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 14.06.2026.
//

import Foundation

final class NetworkService: NetworkServiceProtocol {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func request<T: Decodable>(
        endpoint: Endpoint,
        responseModel: T.Type
    ) async throws -> T {
        
        guard var components = URLComponents(
            string: "https://api.themoviedb.org"
        ) else {
            throw APIError.invalidURL
        }
        
        components.path = endpoint.path
        components.queryItems = endpoint.queryItems
        
        guard let url = components.url else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = endpoint.method.rawValue
        
        request.setValue(
            "Bearer \(APIKey.tmdbToken)",
            forHTTPHeaderField: "Authorization"
        )
        
        request.setValue(
            "application/json",
            forHTTPHeaderField: "accept"
        )
        
        do {
            
            let (data, response) = try await session.data(for: request)
            
            guard let response = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }
            
            guard 200...299 ~= response.statusCode else {
                throw APIError.statusCode(response.statusCode)
            }
            
            do {
                return try JSONDecoder().decode(T.self, from: data)
            } catch {
                throw APIError.decodingError
            }
            
        } catch let error as APIError {
            // İçeride fırlatılan APIError'ları .unknown içine tekrar sarma
            throw error

        } catch let error as URLError {

            switch error.code {
            case .notConnectedToInternet, .networkConnectionLost, .dataNotAllowed:
                throw APIError.noInternet
            default:
                break
            }
            
            throw APIError.unknown(error)
            
        } catch {
            throw APIError.unknown(error)
        }
    }
    
}
