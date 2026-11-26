//
//  TonightEmptyStateView.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 26.11.2026.
//

import SwiftUI

struct TonightEmptyStateView: View {

    let hasFilters: Bool
    let onReset: () -> Void
    let onRetry: () -> Void

    var body: some View {
        ContentUnavailableView {
            Label("No movies match your filters", systemImage: "film.stack")
        } description: {
            Text(hasFilters
                 ? "Try loosening your filters to get more suggestions."
                 : "We couldn't find a new movie to suggest right now.")
        } actions: {
            if hasFilters {
                Button("Reset filters", action: onReset)
                    .buttonStyle(.borderedProminent)
            } else {
                Button("Try again", action: onRetry)
                    .buttonStyle(.borderedProminent)
            }
        }
    }
}
