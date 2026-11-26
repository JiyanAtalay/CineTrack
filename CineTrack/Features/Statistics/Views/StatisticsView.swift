//
//  StatisticsView.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 24.11.2026.
//

import SwiftUI
import SwiftData

struct StatisticsView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = StatisticsViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    
                    // MARK: - Summary Cards
                    summarySection
                    
                    // MARK: - Rating Distribution
                    if viewModel.totalRatedCount > 0 {
                        RatingDistributionChart(data: viewModel.ratingDistribution)
                    }
                    
                    // MARK: - Genre Distribution
                    if !viewModel.genreDistribution.isEmpty {
                        GenreDistributionChart(data: viewModel.genreDistribution)
                    }

                    // MARK: - Favorite Directors
                    if !viewModel.directorDistribution.isEmpty {
                        DirectorDistributionChart(data: viewModel.directorDistribution)
                    }
                    
                    // MARK: - Empty State
                    if viewModel.totalWatchedCount == 0 && viewModel.totalRatedCount == 0 {
                        emptyState
                    }
                }
                .padding()
            }
            .navigationTitle("Statistics")
            .onAppear {
                viewModel.load(context: modelContext)
            }
        }
    }
    
    // MARK: - Summary Cards
    
    private var summarySection: some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ],
            spacing: 14
        ) {
            StatCard(
                title: "Watched",
                value: "\(viewModel.totalWatchedCount)",
                subtitle: "movies",
                icon: "film.fill",
                color: .blue
            )
            
            StatCard(
                title: "Watch Time",
                value: viewModel.totalWatchTimeFormatted,
                subtitle: "total",
                icon: "clock.fill",
                color: .purple
            )
            
            StatCard(
                title: "Avg. Rating",
                value: viewModel.averageRatingFormatted,
                subtitle: viewModel.totalRatedCount > 0 ? "out of 5" : "",
                icon: "star.fill",
                color: .yellow
            )
            
            StatCard(
                title: "Rated",
                value: "\(viewModel.totalRatedCount)",
                subtitle: "movies",
                icon: "hand.thumbsup.fill",
                color: .green
            )
        }
    }
    
    // MARK: - Empty State
    
    private var emptyState: some View {
        ContentUnavailableView(
            "No Statistics Yet",
            systemImage: "chart.bar",
            description: Text("Start watching and rating movies to see your statistics here.")
        )
        .padding(.top, 40)
    }
}

#Preview {
    StatisticsView()
        .modelContainer(for: [WatchlistMovie.self, PersonalMovieRating.self], inMemory: true)
}
