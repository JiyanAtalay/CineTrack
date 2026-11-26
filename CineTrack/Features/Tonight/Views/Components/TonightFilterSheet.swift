//
//  TonightFilterSheet.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 26.11.2026.
//

import SwiftUI

struct TonightFilterSheet: View {

    @Environment(\.dismiss) private var dismiss

    let genres: [Genre]
    let loadGenres: () async -> Void
    let onApply: (DiscoverFilters) -> Void

    /// Değişiklikler Apply'a basılana kadar bu kopyada tutulur.
    @State private var draft: DiscoverFilters

    init(
        filters: DiscoverFilters,
        genres: [Genre],
        loadGenres: @escaping () async -> Void,
        onApply: @escaping (DiscoverFilters) -> Void
    ) {
        self.genres = genres
        self.loadGenres = loadGenres
        self.onApply = onApply
        _draft = State(initialValue: filters)
    }

    private var allYears: [Int] {
        Array((DiscoverFilters.minimumYear...DiscoverFilters.currentYear).reversed())
    }

    private var toYears: [Int] {
        guard let fromYear = draft.fromYear else { return allYears }
        return allYears.filter { $0 >= fromYear }
    }

    var body: some View {
        NavigationStack {
            Form {
                genreSection
                yearSection
                ratingSection
                runtimeSection
                languageSection
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Apply") {
                        onApply(draft)
                        dismiss()
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    Button("Reset", role: .destructive) {
                        draft = .none
                    }
                    .disabled(draft.isEmpty)
                }
            }
            .onChange(of: draft.fromYear) { _, newFrom in
                if let newFrom, let toYear = draft.toYear, toYear < newFrom {
                    draft.toYear = newFrom
                }
            }
            .task {
                await loadGenres()
            }
        }
    }

    // MARK: Sections

    private var genreSection: some View {
        Section {
            if genres.isEmpty {
                HStack {
                    ProgressView()
                    Text("Loading genres…")
                        .foregroundStyle(.secondary)
                }
            } else {
                FlowLayout(spacing: 8) {
                    ForEach(genres) { genre in
                        let isSelected = draft.genreIDs.contains(genre.id)
                        Button {
                            if isSelected {
                                draft.genreIDs.remove(genre.id)
                            } else {
                                draft.genreIDs.insert(genre.id)
                            }
                        } label: {
                            GenreChip(genre: genre, isSelected: isSelected)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.vertical, 4)
            }
        } header: {
            Text("Genres")
        } footer: {
            Text("Movies matching any of the selected genres.")
        }
    }

    private var yearSection: some View {
        Section("Release Year") {
            Picker("From", selection: $draft.fromYear) {
                Text("Any").tag(Int?.none)
                ForEach(allYears, id: \.self) { year in
                    Text(String(year)).tag(Int?.some(year))
                }
            }

            Picker("To", selection: $draft.toYear) {
                Text("Any").tag(Int?.none)
                ForEach(toYears, id: \.self) { year in
                    Text(String(year)).tag(Int?.some(year))
                }
            }
        }
    }

    private var ratingSection: some View {
        Section("Minimum TMDB Rating") {
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundStyle(.yellow)
                    Text(draft.minRating > 0 ? String(format: "%.1f+", draft.minRating) : "Any")
                        .monospacedDigit()
                }
                Slider(value: $draft.minRating, in: 0...9, step: 0.5)
            }
        }
    }

    private var runtimeSection: some View {
        Section("Maximum Runtime") {
            Picker("Runtime", selection: $draft.maxRuntime) {
                ForEach(RuntimeOption.allCases) { option in
                    Text(option.title).tag(option)
                }
            }
            .pickerStyle(.segmented)
        }
    }

    private var languageSection: some View {
        Section("Original Language") {
            Picker("Language", selection: $draft.language) {
                Text("Any").tag(OriginalLanguage?.none)
                ForEach(OriginalLanguage.allCases) { language in
                    Text(language.title).tag(OriginalLanguage?.some(language))
                }
            }
        }
    }
}
