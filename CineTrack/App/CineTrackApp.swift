//
//  CineTrackApp.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 12.06.2026.
//

import SwiftUI
import SwiftData

@main
struct CineTrackApp: App {
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
        .modelContainer(for: [
            WatchlistMovie.self,
            PersonalMovieRating.self
        ])
    }
}
