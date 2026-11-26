//
//  TonightFilterStoreProtocol.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 26.11.2026.
//

import Foundation

protocol TonightFilterStoreProtocol {
    func load() -> DiscoverFilters
    func save(_ filters: DiscoverFilters)
}
