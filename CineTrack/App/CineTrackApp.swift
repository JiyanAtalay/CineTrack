//
//  CineTrackApp.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 12.06.2026.
//

import SwiftUI
import SwiftData
import UIKit

@main
struct CineTrackApp: App {
    @State private var isShowingSplash = true
    @State private var isContentRevealed = false

    var body: some Scene {
        WindowGroup {
            ZStack {
                MainTabView()
                    .scaleEffect(isContentRevealed ? 1 : 0.94)

                if isShowingSplash {
                    LaunchSplashView(
                        onReveal: {
                            let animation: Animation? = UIAccessibility.isReduceMotionEnabled
                                ? nil
                                : .spring(response: 0.6, dampingFraction: 0.9)
                            withAnimation(animation) {
                                isContentRevealed = true
                            }
                        },
                        onFinished: {
                            withAnimation(.easeOut(duration: 0.25)) {
                                isShowingSplash = false
                            }
                        }
                    )
                    .transition(.opacity)
                    .zIndex(1)
                }
            }
        }
        .modelContainer(for: [
            WatchlistMovie.self,
            PersonalMovieRating.self
        ])
    }
}
