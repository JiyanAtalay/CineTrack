//
//  SimilarMoviesSectionView.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 4.07.2026.
//

import Foundation
import SwiftUI

struct SimilarMoviesSectionView: View {
    
    let movies: [Movie]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Similar Movies")
                .font(.title3.bold())
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 16) {
                    ForEach(movies) { movie in
                        NavigationLink {
                            MovieDetailView(movieId: movie.id)
                        } label: {
                            MoviePosterCard(movie: movie)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
        }
    }
}
