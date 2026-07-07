//
//  HeroMovieBanner.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 24.06.2026.
//

import Foundation
import SwiftUI

struct HeroMovieBanner: View {
    
    let movie: Movie
    
    let onTap: () -> Void
    
    var body: some View {
        
        ZStack(alignment: .bottomLeading) {
            CachedAsyncImage(url: movie.backdropURL, placeholder: {
                ImagePlaceholderView()
            })
            .scaledToFill()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            LinearGradient(
                stops: [
                    .init(color: .clear, location: 0.3),
                    .init(color: .black.opacity(0.85), location: 1.0)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            
            VStack(alignment: .leading, spacing: 8) {
                Text(movie.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundStyle(.yellow)
                    
                    Text(movie.ratingText)
                        .foregroundStyle(.white)
                    
                    if movie.releaseDate != nil {
                        Text("• \(movie.releaseYear)")
                            .foregroundStyle(.white.opacity(0.8))
                    }
                }
            }
            .padding()
        }
        .contentShape(RoundedRectangle(cornerRadius: 20))
        .onTapGesture {
            onTap()
        }
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .padding(.horizontal)
    }
}
