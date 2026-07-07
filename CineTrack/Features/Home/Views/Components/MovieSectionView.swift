//
//  MovieSectionView.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 19.06.2026.
//

import Foundation
import SwiftUI

struct MovieSectionView: View {
    
    let title: String
    let movies: [Movie]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.title3)
                .bold()
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
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
            }
        }
    }
}
