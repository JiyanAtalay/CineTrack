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
            content
                .navigationTitle("Search")
                .searchable(text: $viewModel.query, prompt: "Search movies...")
                .onChange(of: viewModel.query) { _, _ in
                    viewModel.searchWithDebounce()
                }
        }
    }

    @ViewBuilder
    private var content: some View {
        if viewModel.trimmedQuery.isEmpty {
            ContentUnavailableView(
                "Search Movies",
                systemImage: "magnifyingglass",
                description: Text("Search for your favorite movies.")
            )
        } else if !viewModel.movies.isEmpty {
            resultsList
        } else if let errorMessage = viewModel.errorMessage {
            ErrorStateView(
                title: "Search Failed",
                message: errorMessage,
                onRetry: { await viewModel.search() }
            )
        } else if viewModel.hasSearched && !viewModel.isLoading {
            ContentUnavailableView.search(text: viewModel.trimmedQuery)
        } else {
            LoadingStateView(message: "Searching…")
        }
    }

    private var resultsList: some View {
        List {
            ForEach(viewModel.movies) { movie in
                NavigationLink {
                    MovieDetailView(movieId: movie.id)
                } label: {
                    SearchMovieRow(movie: movie)
                }
                .task {
                    await viewModel.loadNextPageIfNeeded(currentMovie: movie)
                }
            }

            if viewModel.isLoadingNextPage {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .listRowSeparator(.hidden)
            } else if let nextPageError = viewModel.nextPageErrorMessage {
                VStack(spacing: 8) {
                    Text(nextPageError)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)

                    Button("Load More") {
                        Task { await viewModel.loadNextPage() }
                    }
                    .buttonStyle(.bordered)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .listRowSeparator(.hidden)
            }
        }
        .overlay(alignment: .top) {
            // Yeni sorgu aranırken eski sonuçlar ekranda kalır; üstte küçük bir gösterge
            if viewModel.isLoading {
                ProgressView()
                    .padding(10)
                    .background(.regularMaterial, in: Capsule())
                    .padding(.top, 8)
            }
        }
    }
}
