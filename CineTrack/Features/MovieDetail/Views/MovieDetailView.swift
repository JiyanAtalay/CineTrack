//
//  MovieDetailView.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 2.07.2026.
//

import Foundation
import SwiftUI
import SwiftData

struct MovieDetailView: View {
    @Environment(\.modelContext) private var modelContext
    
    let movieId: Int
    
    @State private var viewModel: MovieDetailViewModel = DIContainer.shared.makeMovieDetailViewModel()
    
    init(movieId: Int) {
        self.movieId = movieId
    }
    
    var body: some View {
        Group {
            if let movie = viewModel.movie {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        MovieHeaderView(movie: movie)
                        MovieActionButtons(movie: movie, trailerURL: viewModel.trailerURL, isInWatchlist: viewModel.isInWatchlist)
                        {
                            viewModel.toggleWatchList()
                        }
                        GenreSectionView(genres: movie.genres)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Overview")
                                .font(.title3.bold())
                            
                            Text(movie.overview)
                        }
                        .padding(.horizontal)
                        
                        if !viewModel.cast.isEmpty {
                            CastSectionView(cast: viewModel.cast)
                        }
                        
                        if !viewModel.similarMovies.isEmpty {
                            SimilarMoviesSectionView(movies: viewModel.similarMovies)
                        }
                    }
                }
            } else {
                ProgressView()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        .task {
            
            viewModel.configure(watchListRepository: WatchlistRepository(context: modelContext))
            
            await viewModel.loadMovie(id: movieId)
        }
    }
}
