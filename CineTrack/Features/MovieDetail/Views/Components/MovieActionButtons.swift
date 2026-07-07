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
    
    let isInWatchlist: Bool
    let toggleWatchlist: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            MovieActionButton(
                title: isInWatchlist ? "Saved" : "Watchlist",
                systemImage: isInWatchlist ? "heart.fill" : "heart")
            {
                toggleWatchlist()
            }
            
            if let url = trailerURL {
                MovieActionButton(title: "Trailer", systemImage: "play.rectangle") {
                    openURL(url)
                }
            }
            
            ShareLink(item: movie.title) {
                VStack {
                    Image(systemName: "square.and.arrow.up")
                        .font(.title2)
                    
                    Text("Share")
                        .font(.caption)
                }
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
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: systemImage)
                    .font(.title2)
                
                Text(title)
                    .font(.caption)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(.thinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 18))
        }
    }
}
