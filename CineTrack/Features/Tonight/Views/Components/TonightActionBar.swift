//
//  TonightActionBar.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 26.11.2026.
//

import SwiftUI

struct TonightActionBar: View {

    let watchStatus: MovieWatchStatus?
    let isFavorite: Bool
    let canPerformActions: Bool
    let isSuggesting: Bool

    let onWatchStatusChange: (MovieWatchStatus) -> Void
    let onToggleFavorite: () -> Void
    let onSuggestAnother: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                MovieActionButton(
                    title: "To Watch",
                    systemImage: watchStatus == .planned ? "bookmark.fill" : "bookmark",
                    isSelected: watchStatus == .planned
                ) {
                    onWatchStatusChange(.planned)
                }

                MovieActionButton(
                    title: "Watched",
                    systemImage: watchStatus == .watched ? "checkmark.circle.fill" : "checkmark.circle",
                    isSelected: watchStatus == .watched
                ) {
                    onWatchStatusChange(.watched)
                }

                MovieActionButton(
                    title: "Favorite",
                    systemImage: isFavorite ? "heart.fill" : "heart",
                    isSelected: isFavorite,
                    tint: .red
                ) {
                    onToggleFavorite()
                }
            }
            .disabled(!canPerformActions)
            .opacity(canPerformActions ? 1 : 0.5)

            Button(action: onSuggestAnother) {
                Label("Suggest Another", systemImage: "shuffle")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 6)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .disabled(isSuggesting)
        }
        .padding(.horizontal)
    }
}
