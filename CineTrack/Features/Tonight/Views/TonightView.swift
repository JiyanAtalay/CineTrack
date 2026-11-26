//
//  TonightView.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 26.11.2026.
//

import SwiftUI
import SwiftData

struct TonightView: View {

    @Environment(\.modelContext) private var modelContext

    @State private var viewModel: TonightViewModel = DIContainer.shared.makeTonightViewModel()
    @State private var selectedMovie: Movie?
    @State private var isShowingFilters = false
    @State private var isOverviewExpanded = false
    /// Kapalı durumdaki poster yüksekliği; overview açılınca poster bu boyutta sabit kalır.
    @State private var collapsedPosterHeight: CGFloat = 0

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("What to Watch Tonight?")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        filterButton
                    }
                }
                .navigationDestination(item: $selectedMovie) { movie in
                    MovieDetailView(movieId: movie.id)
                }
                .sheet(isPresented: $isShowingFilters) {
                    TonightFilterSheet(
                        filters: viewModel.filters,
                        genres: viewModel.genres,
                        loadGenres: { await viewModel.loadGenresIfNeeded() },
                        onApply: { newFilters in
                            Task { await viewModel.applyFilters(newFilters) }
                        }
                    )
                }
                .task {
                    viewModel.configure(watchListRepository: WatchlistRepository(context: modelContext))
                    // İlk açılışta film çeker; detaydan dönüşte sadece durumu tazeler.
                    await viewModel.loadInitial()
                }
        }
    }

    @ViewBuilder
    private var content: some View {
        if let movie = viewModel.movie {
            // Varsayılan: içerik ekrana tam sığar, kaydırma kapalı.
            // "Read more" açılınca içerik uzar ve kaydırma açılır.
            GeometryReader { proxy in
                ScrollView {
                    movieContent(movie)
                        .frame(height: isOverviewExpanded ? nil : proxy.size.height)
                }
                .scrollDisabled(!isOverviewExpanded)
                .scrollBounceBehavior(.basedOnSize)
            }
            .onChange(of: movie.id) {
                isOverviewExpanded = false
            }
        } else if viewModel.isLoading {
            ProgressView()
        } else if let errorMessage = viewModel.errorMessage {
            ContentUnavailableView {
                Label("Something went wrong", systemImage: "wifi.exclamationmark")
            } description: {
                Text(errorMessage)
            } actions: {
                Button("Retry") {
                    Task { await viewModel.suggestAnother() }
                }
                .buttonStyle(.borderedProminent)
            }
        } else if viewModel.isEmptyResult {
            TonightEmptyStateView(
                hasFilters: !viewModel.filters.isEmpty,
                onReset: { Task { await viewModel.resetFilters() } },
                onRetry: { Task { await viewModel.resetFilters() } }
            )
        } else {
            ProgressView()
        }
    }

    private func movieContent(_ movie: Movie) -> some View {
        VStack(spacing: 16) {
            TonightMovieCard(
                movie: movie,
                detail: viewModel.detail,
                isLoadingDetail: viewModel.isLoadingDetail,
                detailFailed: viewModel.detailFailed,
                fixedPosterHeight: isOverviewExpanded ? collapsedPosterHeight : nil,
                isOverviewExpanded: isOverviewExpanded,
                onTap: { selectedMovie = movie },
                onRetryDetail: { Task { await viewModel.reloadDetail() } },
                onToggleOverview: {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        isOverviewExpanded.toggle()
                    }
                },
                onPosterHeightChange: { height in
                    if !isOverviewExpanded {
                        collapsedPosterHeight = height
                    }
                }
            )
            .opacity(viewModel.isLoading ? 0.4 : 1)
            .overlay {
                if viewModel.isLoading {
                    ProgressView()
                        .controlSize(.large)
                }
            }

            TonightActionBar(
                watchStatus: viewModel.watchStatus,
                isFavorite: viewModel.isFavorite,
                canPerformActions: viewModel.canPerformActions,
                isSuggesting: viewModel.isLoading,
                onWatchStatusChange: { status in
                    Task { await viewModel.setWatchStatus(status) }
                },
                onToggleFavorite: { viewModel.toggleFavorite() },
                onSuggestAnother: { Task { await viewModel.suggestAnother() } }
            )
        }
        .padding(.vertical, 12)
    }

    private var filterButton: some View {
        Button {
            isShowingFilters = true
        } label: {
            Image(systemName: viewModel.filters.isEmpty
                  ? "line.3.horizontal.decrease.circle"
                  : "line.3.horizontal.decrease.circle.fill")
                .overlay(alignment: .topTrailing) {
                    if viewModel.filters.activeCount > 0 {
                        Text("\(viewModel.filters.activeCount)")
                            .font(.caption2.bold())
                            .foregroundStyle(.white)
                            .padding(4)
                            .background(Circle().fill(.red))
                            .offset(x: 8, y: -8)
                    }
                }
        }
        .accessibilityLabel("Filters")
    }
}

#Preview {
    TonightView()
}
