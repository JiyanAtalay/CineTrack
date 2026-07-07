//
//  SearchView.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 27.06.2026.
//

import Foundation
import SwiftUI

struct SearchView: View {
    
    @State private var viewModel: SearchViewModel = DIContainer.shared.makeSearchViewModel()
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView()
                } else if viewModel.movies.isEmpty {
                    ContentUnavailableView("Search Movies", image: "magnifyingglass", description: Text("Search for your favorite movies."))
                } else {
                    List(viewModel.movies) { movie in
                        NavigationLink {
                            MovieDetailView(movieId: movie.id)
                        } label: {
                            SearchMovieRow(movie: movie)
                        }
                        .task {
                            await viewModel.loadNextPageIfNeeded(currentMovie: movie)
                        }
                    }
                }
            }
            .navigationTitle("Search")
            .searchable(text: $viewModel.query, prompt: "Search movies...")
            .onChange(of: viewModel.query) { _, _ in
                viewModel.searchWithDebounce()
            }
        }
    }
}
