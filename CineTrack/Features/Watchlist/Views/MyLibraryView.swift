//
//  MyLibraryView.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 19.11.2026.
//

import SwiftUI
import SwiftData

private enum LibraryTab: String, CaseIterable {
    case toWatch
    case watched
    case favorites

    var title: String {
        switch self {
        case .toWatch: "To Watch"
        case .watched: "Watched"
        case .favorites: "Favorites"
        }
    }

    var emptyTitle: String {
        switch self {
        case .toWatch: "Your Watchlist is Empty"
        case .watched: "No Watched Movies"
        case .favorites: "No Favorite Movies"
        }
    }

    var emptyDescription: String {
        switch self {
        case .toWatch:
            "Movies you want to watch will appear here."
        case .watched:
            "Movies you have watched will appear here."
        case .favorites:
            "Your favorite movies will appear here."
        }
    }

    var emptyIcon: String {
        switch self {
        case .toWatch: "bookmark"
        case .watched: "checkmark.circle"
        case .favorites: "heart"
        }
    }
}

struct MyLibraryView: View {
    @Environment(\.modelContext) private var modelContext

    @Query(
        filter: #Predicate<WatchlistMovie> {
            $0.watchStatus == "planned"
        },
        sort: \WatchlistMovie.title
    )
    private var plannedMovies: [WatchlistMovie]

    @Query(
        filter: #Predicate<WatchlistMovie> {
            $0.watchStatus == "watched"
        },
        sort: \WatchlistMovie.title
    )
    private var watchedMovies: [WatchlistMovie]

    @Query(
        filter: #Predicate<WatchlistMovie> {
            $0.isFavorite == true
        },
        sort: \WatchlistMovie.title
    )
    private var favoriteMovies: [WatchlistMovie]

    @State private var selectedTab: LibraryTab = .toWatch
    @State private var errorMessage: String?

    private var displayedMovies: [WatchlistMovie] {
        switch selectedTab {
        case .toWatch:
            plannedMovies
        case .watched:
            watchedMovies
        case .favorites:
            favoriteMovies
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 18) {

                // MARK: - Tabs

                Picker("Library", selection: $selectedTab) {
                    ForEach(LibraryTab.allCases, id: \.self) { tab in
                        Text(tab.title)
                            .tag(tab)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                // MARK: - Movie Count

                HStack {
                    Text(selectedTab.title)
                        .font(.headline)

                    Spacer()

                    Text("\(displayedMovies.count) movies")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal)

                // MARK: - Content

                if displayedMovies.isEmpty {
                    ContentUnavailableView(
                        selectedTab.emptyTitle,
                        systemImage: selectedTab.emptyIcon,
                        description: Text(selectedTab.emptyDescription)
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                } else {
                    ScrollView {
                        LazyVGrid(
                            columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ],
                            spacing: 20
                        ) {
                            ForEach(displayedMovies) { movie in

                                NavigationLink {
                                    MovieDetailView(movieId: movie.id)
                                } label: {
                                    WatchlistMovieCard(movie: movie)
                                }
                                .buttonStyle(.plain)
                                .contextMenu {
                                    movieContextMenu(for: movie)
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .padding(.top, 8)
            .navigationTitle("My Library")
            .alert(
                "Couldn't Update Library",
                isPresented: Binding(
                    get: { errorMessage != nil },
                    set: { if !$0 { errorMessage = nil } }
                )
            ) {
                Button("OK", role: .cancel) {
                    errorMessage = nil
                }
            } message: {
                Text(errorMessage ?? "An unknown error occurred.")
            }
        }
    }

    // MARK: - Context Menu

    @ViewBuilder
    private func movieContextMenu(
        for movie: WatchlistMovie
    ) -> some View {

        if selectedTab == .toWatch {
            Button {
                changeWatchStatus(.watched, for: movie)
            } label: {
                Label("Mark as Watched", systemImage: "checkmark.circle")
            }

            Button {
                toggleFavorite(for: movie)
            } label: {
                Label("Add to Favorites", systemImage: "heart")
            }

            Button(role: .destructive) {
                removeFromCurrentSection(movie)
            } label: {
                Label(
                    selectedTab == .favorites
                        ? "Remove from Favorites"
                        : "Remove from List",
                    systemImage: "trash"
                )
            }

        } else if selectedTab == .watched {
            Button {
                changeWatchStatus(.planned, for: movie)
            } label: {
                Label("Move to To Watch", systemImage: "bookmark")
            }

            Button {
                toggleFavorite(for: movie)
            } label: {
                Label("Add to Favorites", systemImage: "heart")
            }

            Button(role: .destructive) {
                removeFromCurrentSection(movie)
            } label: {
                Label(
                    selectedTab == .favorites
                        ? "Remove from Favorites"
                        : "Remove from List",
                    systemImage: "trash"
                )
            }

        } else {
            Button {
                changeWatchStatus(.planned, for: movie)
            } label: {
                Label("Move to To Watch", systemImage: "bookmark")
            }

            Button {
                changeWatchStatus(.watched, for: movie)
            } label: {
                Label("Mark as Watched", systemImage: "checkmark.circle")
            }

            Button(role: .destructive) {
                removeFromCurrentSection(movie)
            } label: {
                Label(
                    selectedTab == .favorites
                        ? "Remove from Favorites"
                        : "Remove from List",
                    systemImage: "trash"
                )
            }
        }
    }

    // MARK: - Actions

    private func changeWatchStatus(
        _ status: MovieWatchStatus,
        for movie: WatchlistMovie
    ) {
        movie.watchStatus = status.rawValue
        saveChanges()
    }

    private func toggleFavorite(for movie: WatchlistMovie) {
        movie.isFavorite.toggle()
        saveChanges()
    }

    private func removeFromCurrentSection(
        _ movie: WatchlistMovie
    ) {
        if selectedTab == .favorites {
            movie.isFavorite = false
        } else {
            movie.watchStatus = nil
        }

        deleteIfUnused(movie)
        saveChanges()
    }

    private func deleteIfUnused(_ movie: WatchlistMovie) {
        if movie.watchStatus == nil && !movie.isFavorite {
            modelContext.delete(movie)
        }
    }

    private func saveChanges() {
        do {
            try modelContext.save()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
