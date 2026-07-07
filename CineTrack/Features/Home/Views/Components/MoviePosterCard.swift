//
//  MoviePosterCard.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 19.06.2026.
//

import Foundation
import SwiftUI

struct MoviePosterCard: View {
    
    let movie: Movie
    
    var body: some View {
        VStack(alignment: .leading) {
            CachedAsyncImage(url: movie.posterURL) {
                ImagePlaceholderView()
            }
            .scaledToFill()
            .frame(width: 140, height: 210)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            Text(movie.title)
                .font(.caption)
                .lineLimit(2)
                .frame(width: 140)
        }
    }
}
