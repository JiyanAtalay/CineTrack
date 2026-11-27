//
//  PersonDetailViewModel.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 25.11.2026.
//

import Foundation
import Observation

@MainActor
@Observable
final class PersonDetailViewModel {
    static let primaryLanguage = "tr-TR"
    static let fallbackLanguage = "en-US"

    private let service: PersonServiceProtocol
    private var watchListRepository: WatchlistRepositoryProtocol?

    private(set) var person: PersonDetailResponse?
    private(set) var movies: [Movie] = []
    private(set) var watchedCount = 0

    private(set) var isLoading = false
    private(set) var errorMessage: String?

    init(service: PersonServiceProtocol) {
        self.service = service
    }

    func configure(watchListRepository: WatchlistRepositoryProtocol) {
        self.watchListRepository = watchListRepository
    }

    func load(id: Int, role: PersonCreditRole) async {
        isLoading = true
        errorMessage = nil

        defer {
            isLoading = false
        }

        do {
            async let detail = service.fetchPersonDetail(id: id, language: Self.primaryLanguage)
            async let credits = service.fetchMovieCredits(id: id)

            var loadedPerson = try await detail
            let loadedCredits = try await credits

            // Türkçe biyografi yoksa İngilizcesini dene; başarısız olursa sayfayı bozma
            if loadedPerson.biography.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
               let fallback = try? await service.fetchPersonDetail(id: id, language: Self.fallbackLanguage),
               !fallback.biography.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                loadedPerson = loadedPerson.withBiography(fallback.biography)
            }

            person = loadedPerson
            movies = Self.movies(from: loadedCredits, role: role)
            refreshWatchedCount()
        } catch {
            guard !error.isCancellation else { return }
            errorMessage = error.localizedDescription
        }
    }

    func refreshWatchedCount() {
        guard let watchListRepository, !movies.isEmpty else {
            watchedCount = 0
            return
        }

        let watchedIDs = Set(watchListRepository.fetchWatched().map(\.id))
        watchedCount = movies.filter { watchedIDs.contains($0.id) }.count
    }

    /// Role göre kredileri seçer, aynı filmi tekilleştirir ve popülerliğe göre sıralar.
    static func movies(from credits: PersonMovieCreditsResponse, role: PersonCreditRole) -> [Movie] {
        let selected: [PersonMovieCredit]

        switch role {
        case .acting:
            selected = credits.cast
        case .directing:
            selected = credits.crew.filter { $0.job == "Director" }
        }

        var seenIDs = Set<Int>()
        let unique = selected.filter { seenIDs.insert($0.id).inserted }

        return unique
            .sorted { ($0.popularity ?? 0) > ($1.popularity ?? 0) }
            .map(\.asMovie)
    }
}
