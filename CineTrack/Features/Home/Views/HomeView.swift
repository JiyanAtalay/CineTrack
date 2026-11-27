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
                if viewModel.hasContent {
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
                    .refreshable {
                        await viewModel.fetchHomeData()
                    }
                } else if let errorMessage = viewModel.errorMessage {
                    ErrorStateView(
                        title: "Couldn't Load Movies",
                        message: errorMessage,
                        onRetry: { await viewModel.fetchHomeData() }
                    )
                } else if viewModel.isLoading || !viewModel.hasLoaded {
                    LoadingStateView(message: "Loading movies…")
                } else {
                    ContentUnavailableView {
                        Label("No Movies Yet", systemImage: "film")
                    } description: {
                        Text("There's nothing to show right now. Please check back later.")
                    } actions: {
                        Button("Refresh") {
                            Task { await viewModel.fetchHomeData() }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
            }
            .navigationTitle("CineTrack")
            .navigationDestination(item: $selectedMovie) { movie in
                MovieDetailView(movieId: movie.id)
            }
            .task {
                if !viewModel.hasLoaded {
                    await viewModel.fetchHomeData()
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
