//
//  PersonService.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 25.11.2026.
//

import Foundation

final class PersonService: PersonServiceProtocol {

    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }

    func fetchPersonDetail(id: Int, language: String) async throws -> PersonDetailResponse {
        try await networkService.request(
            endpoint: TMDBEndpoint.personDetail(id: id, language: language),
            responseModel: PersonDetailResponse.self
        )
    }

    func fetchMovieCredits(id: Int) async throws -> PersonMovieCreditsResponse {
        try await networkService.request(
            endpoint: TMDBEndpoint.personMovieCredits(id: id),
            responseModel: PersonMovieCreditsResponse.self
        )
    }
}
