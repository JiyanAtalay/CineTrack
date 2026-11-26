//
//  MockTonightService.swift
//  CineTrackTests
//
//  Created by Mehmet Jiyan Atalay on 26.11.2026.
//

import Foundation
@testable import CineTrack

final class MockTonightService: TonightServiceProtocol {
    var genres: [Genre] = []
    /// Sayfa numarası -> response. Tanımsız sayfalar boş döner.
    var pages: [Int: TrendingMoviesResponse] = [:]
    var error: Error?

    private(set) var requestedPages: [Int] = []
    private(set) var requestedFilters: [DiscoverFilters] = []
    private(set) var fetchGenresCallCount = 0

    func fetchGenres() async throws -> [Genre] {
        fetchGenresCallCount += 1
        if let error { throw error }
        return genres
    }

    func discoverMovies(filters: DiscoverFilters, page: Int) async throws -> TrendingMoviesResponse {
        requestedPages.append(page)
        requestedFilters.append(filters)
        if let error { throw error }
        return pages[page] ?? TrendingMoviesResponse(page: page, results: [], totalPages: 0, totalResults: 0)
    }
}
