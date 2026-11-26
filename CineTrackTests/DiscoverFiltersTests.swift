//
//  DiscoverFiltersTests.swift
//  CineTrackTests
//
//  Created by Mehmet Jiyan Atalay on 26.11.2026.
//

import Foundation
import Testing
@testable import CineTrack

@Suite("DiscoverFilters Tests")
@MainActor
struct DiscoverFiltersTests {

    private func value(_ name: String, in items: [URLQueryItem]) -> String? {
        items.first { $0.name == name }?.value
    }

    @Test("Empty filters only send the hidden baseline parameters")
    func emptyFiltersBaseline() {
        let items = DiscoverFilters.none.queryItems

        #expect(value("vote_count.gte", in: items) == "200")
        #expect(value("include_adult", in: items) == "false")
        #expect(value("sort_by", in: items) == "popularity.desc")
        #expect(items.count == 3)
        #expect(DiscoverFilters.none.isEmpty)
        #expect(DiscoverFilters.none.activeCount == 0)
    }

    @Test("All filters are mapped to TMDB discover parameters")
    func allFiltersMapped() {
        let filters = DiscoverFilters(
            genreIDs: [28, 12],
            fromYear: 1990,
            toYear: 2000,
            minRating: 7,
            maxRuntime: .under120,
            language: .korean
        )
        let items = filters.queryItems

        #expect(value("with_genres", in: items) == "12|28")
        #expect(value("primary_release_date.gte", in: items) == "1990-01-01")
        #expect(value("primary_release_date.lte", in: items) == "2000-12-31")
        #expect(value("vote_average.gte", in: items) == "7.0")
        #expect(value("with_runtime.lte", in: items) == "120")
        #expect(value("with_original_language", in: items) == "ko")
        #expect(filters.activeCount == 5)
        #expect(!filters.isEmpty)
    }

    @Test("Year range counts as a single active filter")
    func yearRangeSingleFilter() {
        let filters = DiscoverFilters(fromYear: 2010)

        #expect(filters.activeCount == 1)
        #expect(value("primary_release_date.lte", in: filters.queryItems) == nil)
    }

    @Test("Discover endpoint adds page and language")
    func discoverEndpointQuery() {
        let endpoint = TMDBEndpoint.discover(filters: .none, page: 7)

        #expect(endpoint.path == "/3/discover/movie")
        #expect(value("page", in: endpoint.queryItems) == "7")
        #expect(value("language", in: endpoint.queryItems) == "tr-TR")
    }

    @Test("Filters survive a UserDefaults round trip")
    func userDefaultsRoundTrip() throws {
        let suiteName = "DiscoverFiltersTests.\(UUID().uuidString)"
        let defaults = try #require(UserDefaults(suiteName: suiteName))
        defer { defaults.removePersistentDomain(forName: suiteName) }

        let store = UserDefaultsTonightFilterStore(defaults: defaults)
        #expect(store.load() == .none)

        let filters = DiscoverFilters(genreIDs: [18], minRating: 6.5, language: .turkish)
        store.save(filters)

        #expect(store.load() == filters)
    }
}
