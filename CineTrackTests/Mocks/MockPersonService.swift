//
//  MockPersonService.swift
//  CineTrackTests
//
//  Created by Mehmet Jiyan Atalay on 25.11.2026.
//

import Foundation
@testable import CineTrack

final class MockPersonService: PersonServiceProtocol {
    var details: [String: PersonDetailResponse] = [:]
    var credits = PersonMovieCreditsResponse(cast: [], crew: [])

    var error: Error?
    var errorsByLanguage: [String: Error] = [:]

    private(set) var requestedLanguages: [String] = []

    func fetchPersonDetail(id: Int, language: String) async throws -> PersonDetailResponse {
        requestedLanguages.append(language)

        if let error {
            throw error
        }
        if let languageError = errorsByLanguage[language] {
            throw languageError
        }
        return details[language] ?? PersonDetailResponse(id: id, name: "Unknown")
    }

    func fetchMovieCredits(id: Int) async throws -> PersonMovieCreditsResponse {
        if let error {
            throw error
        }
        return credits
    }
}
