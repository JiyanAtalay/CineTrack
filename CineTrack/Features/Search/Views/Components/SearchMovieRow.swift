//
//  SearchMovieRow.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 4.07.2026.
//

import Foundation
import SwiftUI

struct SearchMovieRow: View {
    let movie: Movie
    
    var body: some View {
        HStack(spacing: 12) {
            CachedAsyncImage(url: movie.posterURL) {
                ImagePlaceholderView()
            }
            .scaledToFill()
            .frame(width: 60, height: 90)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            VStack(alignment: .leading) {
                Text(movie.title)
                    .font(.headline)
                
                if let releaseDate = movie.releaseDate {
                    Text(releaseDate)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}
