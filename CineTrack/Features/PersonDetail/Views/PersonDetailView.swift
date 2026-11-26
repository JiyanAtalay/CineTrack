//
//  PersonDetailView.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 25.11.2026.
//

import Foundation
import SwiftUI
import SwiftData

struct PersonDetailView: View {
    @Environment(\.modelContext) private var modelContext

    let route: PersonRoute

    @State private var viewModel: PersonDetailViewModel = DIContainer.shared.makePersonDetailViewModel()

    var body: some View {
        Group {
            if let person = viewModel.person {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        PersonHeaderView(person: person)

                        if !person.biography.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            PersonBiographyView(biography: person.biography)
                        }

                        moviesSection
                    }
                    .padding(.vertical)
                }
            } else if let errorMessage = viewModel.errorMessage {
                ContentUnavailableView(
                    "Couldn't load \(route.name)",
                    systemImage: "exclamationmark.triangle",
                    description: Text(errorMessage)
                )
            } else {
                ProgressView()
            }
        }
        .navigationTitle(route.name)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            guard viewModel.person == nil else { return }
            viewModel.configure(watchListRepository: WatchlistRepository(context: modelContext))
            await viewModel.load(id: route.id, role: route.role)
        }
        .onAppear {
            viewModel.refreshWatchedCount()
        }
    }

    private var moviesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text(route.role.title)
                    .font(.title3.bold())

                Text(summaryText)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal)

            if viewModel.movies.isEmpty {
                Text("No movies found")
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 32)
            } else {
                PersonMoviesGridView(movies: viewModel.movies)
            }
        }
    }

    private var summaryText: String {
        let count = viewModel.movies.count
        let moviesText = count == 1 ? "1 movie" : "\(count) movies"
        return "\(moviesText) · You've watched \(viewModel.watchedCount)"
    }
}
