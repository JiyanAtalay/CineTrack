//
//  MoviePosterCard.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 19.06.2026.
//

import Foundation
import SwiftUI
import SwiftData

struct MoviePosterCard: View {
    
    let movie: Movie
    var posterWidth: CGFloat = 140
    @Environment(\.modelContext) private var modelContext
    
    @State private var isFavorite = false
    @State private var watchStatus: MovieWatchStatus?
    
    var body: some View {
        VStack(alignment: .leading) {
            CachedAsyncImage(url: movie.posterURL) {
                ImagePlaceholderView()
            }
            .scaledToFill()
            .frame(width: posterWidth, height: posterWidth * 1.5)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(alignment: .topLeading) {
                if let watchStatus {
                    WatchStatusBadge(status: watchStatus)
                        .padding(6)
                }
            }
            .overlay(alignment: .topTrailing) {
                if isFavorite {
                    FavoriteBadge()
                        .padding(6)
                }
            }
            
            Text(movie.title)
                .font(.caption)
                .lineLimit(2)
                .frame(width: posterWidth, height: 32, alignment: .topLeading)
        }
        .onAppear {
            refreshStatus()
        }
    }
    
    private func refreshStatus() {
        let movieId = movie.id
        let descriptor = FetchDescriptor<WatchlistMovie>(
            predicate: #Predicate { $0.id == movieId }
        )
        let result = try? modelContext.fetch(descriptor).first
        isFavorite = result?.isFavorite ?? false
        watchStatus = result?.movieWatchStatus
    }
}
