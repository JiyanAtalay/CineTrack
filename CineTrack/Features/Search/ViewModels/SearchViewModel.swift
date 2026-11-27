//
//  SearchViewModel.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 27.06.2026.
//

import Foundation
import Observation

@MainActor
@Observable
final class SearchViewModel {

    private let searchService: SearchServiceProtocol

    var query = ""

    private var currentPage = 1
    private var totalPages = 1

    private(set) var movies: [Movie] = []

    var isLoading = false
    private(set) var isLoadingNextPage = false
    var errorMessage: String?
    /// Sonraki sayfa yüklenemediğinde liste altında gösterilir; ana sonuçları gizlemez.
    private(set) var nextPageErrorMessage: String?

    /// Mevcut sorgu için arama tamamlandı mı; "sonuç yok" durumunu debounce beklemesinden ayırır.
    private(set) var hasSearched = false

    private var searchTask: Task<Void, Never>?

    var trimmedQuery: String {
        query.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var canLoadMore: Bool {
        currentPage < totalPages
    }

    init(searchService: SearchServiceProtocol) {
        self.searchService = searchService
    }

    func search() async {
        guard !trimmedQuery.isEmpty else {
            movies = []
            currentPage = 1
            totalPages = 1
            errorMessage = nil
            nextPageErrorMessage = nil
            hasSearched = false
            return
        }

        currentPage = 1
        isLoading = true
        errorMessage = nil
        nextPageErrorMessage = nil

        defer {
            isLoading = false
        }

        do {
            let response = try await searchService.searchMovie(query: query, page: 1)
            // Bu arada yeni bir arama başladıysa eski sonuçları yazma
            guard !Task.isCancelled else { return }

            movies = response.results
            totalPages = response.totalPages
            hasSearched = true

        } catch {
            guard !error.isCancellation else { return }
            movies = []
            totalPages = 1
            errorMessage = error.localizedDescription
            hasSearched = true
        }
    }

    func searchWithDebounce() {
        searchTask?.cancel()
        hasSearched = false

        searchTask = Task {
            try? await Task.sleep(for: .milliseconds(500))

            guard !Task.isCancelled else { return }

            await search()
        }
    }

    func loadNextPageIfNeeded(currentMovie: Movie) async {
        guard movies.last?.id == currentMovie.id else { return }

        await loadNextPage()
    }

    func loadNextPage() async {
        guard canLoadMore, !isLoading, !isLoadingNextPage else { return }

        isLoadingNextPage = true
        nextPageErrorMessage = nil

        defer {
            isLoadingNextPage = false
        }

        let nextPage = currentPage + 1

        do {
            let response = try await searchService.searchMovie(query: query, page: nextPage)

            movies.append(contentsOf: response.results)
            currentPage = nextPage
            totalPages = response.totalPages

        } catch {
            guard !error.isCancellation else { return }
            nextPageErrorMessage = error.localizedDescription
        }
    }
}
