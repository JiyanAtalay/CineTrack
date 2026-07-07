//
//  NetworkServiceProtocol.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 14.06.2026.
//

import Foundation

protocol NetworkServiceProtocol {
    func request<T: Decodable>(
        endpoint: Endpoint,
        responseModel: T.Type
    ) async throws -> T
}
