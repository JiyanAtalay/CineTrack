//
//  MovieActionButtons.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 2.07.2026.
//

import Foundation
import SwiftUI

struct MovieActionButtons: View {
    @Environment(\.openURL) private var openURL
    
    let movie: MovieDetailResponse
    let trailerURL: URL?
    
    let watchStatus: MovieWatchStatus?
    let isFavorite: Bool
    
    let onWatchStatusChange: (MovieWatchStatus) -> Void
    let onToggleFavorite: () -> Void
    
    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            MovieActionButton(
                title: "To Watch",
                systemImage: watchStatus == .planned
                ? "bookmark.fill" : "bookmark",
                isSelected: watchStatus == .planned
            ) {
                onWatchStatusChange(.planned)
            }
            
            MovieActionButton(
                title: "Watched",
                systemImage: watchStatus == .watched
                ? "checkmark.circle.fill" : "checkmark.circle",
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
            
            if let url = trailerURL {
                MovieActionButton(
                    title: "Trailer",
                    systemImage: "play.rectangle"
                ) {
                    openURL(url)
                }
            }
            
            ShareLink(item: movie.title) {
                VStack(spacing: 8) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.title2)
                    
                    Text("Share")
                        .font(.caption)
                }
                .foregroundStyle(.primary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 18))
            }
        }
        .padding(.horizontal)
    }
}

struct MovieActionButton: View {
    let title: String
    let systemImage: String
    var isSelected: Bool = false
    var tint: Color = .accentColor
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: systemImage)
                    .font(.title2)

                Text(title)
                    .font(.caption)
            }
            .foregroundStyle(isSelected ? tint : .primary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(
                isSelected ? tint.opacity(0.12) : Color.clear
            )
            .background(.thinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 18))
        }
        .buttonStyle(.plain)
    }
}
