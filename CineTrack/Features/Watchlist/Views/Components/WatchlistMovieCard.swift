//
//  WatchlistMovieCard.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 4.07.2026.
//

import Foundation
import SwiftUI

struct WatchlistMovieCard: View {
    
    let movie: WatchlistMovie
    
    var body: some View {
        VStack(alignment: .leading) {
            CachedAsyncImage(url: movie.posterURL) {
                ImagePlaceholderView()
            }
            .scaledToFill()
            .frame(height: 220)
            .frame(maxWidth: .infinity)
            .clipped()
            .clipShape(RoundedRectangle(cornerRadius: 16))
            
            Text(movie.title)
                .font(.headline)
                .lineLimit(2)
            
            HStack {
                Image(systemName: "star.fill")
                    .foregroundStyle(.yellow)
                
                Text(String(format: "%.1f", movie.voteAverage))
                    .font(.caption)
                
                Spacer()
                
                Text(movie.releaseDate?.formattedDate ?? "")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
