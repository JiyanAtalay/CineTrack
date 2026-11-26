//
//  MainTabView.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 27.06.2026.
//

import Foundation
import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: AppTab = .home

    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Home", systemImage: "house.fill", value: AppTab.home) {
                HomeView()
            }

            Tab("Search", systemImage: "magnifyingglass", value: AppTab.search) {
                SearchView()
            }

            Tab(value: AppTab.tonight) {
                TonightView()
            } label: {
                Label {
                    Text("Tonight")
                } icon: {
                    Image(uiImage: TonightTabIcon.image)
                        .renderingMode(.original)
                }
            }

            Tab("Watchlist", systemImage: "bookmark.fill", value: AppTab.watchlist) {
                WatchlistView()
            }

            Tab("Statistics", systemImage: "chart.dots.scatter", value: AppTab.statistics) {
                StatisticsView()
            }
        }
    }
}

#Preview {
    MainTabView()
}
