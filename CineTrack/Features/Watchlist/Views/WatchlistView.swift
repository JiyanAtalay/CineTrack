//
//  WatchlistView.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 4.07.2026.
//

import Foundation
import SwiftUI
import SwiftData

struct WatchlistView:View {
    @Query(sort: \WatchlistMovie.title) private var movies: [WatchlistMovie]
    
    var body: some View {
        NavigationStack {
            Group {
                if movies.isEmpty {
                    ContentUnavailableView("Watchlist Empty", systemImage: "heart", description: Text("Add movies to your watchlist."))
                } else {
                    ScrollView {
                        LazyVGrid(
                            columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ],
                            spacing: 20
                        ) {
                            ForEach(movies) { movie in
                                NavigationLink {
                                    MovieDetailView(movieId: movie.id)
                                } label: {
                                    WatchlistMovieCard(movie: movie)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Watchlist")
        }
    }
}
