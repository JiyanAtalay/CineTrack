//
//  PersonMoviesGridView.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 25.11.2026.
//

import Foundation
import SwiftUI

struct PersonMoviesGridView: View {

    let movies: [Movie]

    // 3 sütun + boşluklar küçük ekranlara (375pt) da sığacak şekilde
    private let posterWidth: CGFloat = 104
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 12, alignment: .top), count: 3)

    var body: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(movies) { movie in
                NavigationLink {
                    MovieDetailView(movieId: movie.id)
                } label: {
                    MoviePosterCard(movie: movie, posterWidth: posterWidth)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal)
    }
}
