//
//  MockTonightFilterStore.swift
//  CineTrackTests
//
//  Created by Mehmet Jiyan Atalay on 26.11.2026.
//

import Foundation
@testable import CineTrack

final class MockTonightFilterStore: TonightFilterStoreProtocol {
    var storedFilters: DiscoverFilters = .none
    private(set) var saveCallCount = 0

    func load() -> DiscoverFilters {
        storedFilters
    }

    func save(_ filters: DiscoverFilters) {
        storedFilters = filters
        saveCallCount += 1
    }
}
