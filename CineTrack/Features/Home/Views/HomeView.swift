//
//  ContentView.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 12.06.2026.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    
    @State private var viewModel: HomeViewModel = DIContainer.shared.makeHomeViewModel()
    @State private var selectedMovie: Movie?
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 24) {
                            
                            if let featuredMovie = viewModel.trendingMovies.first {
                                HeroMovieBanner(
                                    movie: featuredMovie,
                                    onTap: {
                                        selectedMovie = featuredMovie
                                    }
                                )
                            }
                            
                            MovieSectionView(title: "Trending", movies: viewModel.trendingMovies)
                            MovieSectionView(title: "Populer", movies: viewModel.populerMovies)
                            MovieSectionView(title: "Top Rated", movies: viewModel.topRatedMovies)
                        }
                    }
                }
            }
            .navigationTitle("CineTrack")
            .navigationDestination(item: $selectedMovie) { movie in
                MovieDetailView(movieId: movie.id)
            }
            .task {
                if viewModel.trendingMovies.isEmpty {
                    await viewModel.fetchHomeData()
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
