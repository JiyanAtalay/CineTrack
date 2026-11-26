//
//  UserDefaultsTonightFilterStore.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 26.11.2026.
//

import Foundation

/// Filtreleri JSON olarak UserDefaults'ta saklar; uygulama yeniden açıldığında korunur.
final class UserDefaultsTonightFilterStore: TonightFilterStoreProtocol {

    private let defaults: UserDefaults
    private let key: String

    init(defaults: UserDefaults = .standard, key: String = "tonight.discoverFilters") {
        self.defaults = defaults
        self.key = key
    }

    func load() -> DiscoverFilters {
        guard let data = defaults.data(forKey: key),
              let filters = try? JSONDecoder().decode(DiscoverFilters.self, from: data) else {
            return .none
        }
        return filters
    }

    func save(_ filters: DiscoverFilters) {
        guard let data = try? JSONEncoder().encode(filters) else { return }
        defaults.set(data, forKey: key)
    }
}
