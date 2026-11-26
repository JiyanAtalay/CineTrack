//
//  TonightViewModel.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 26.11.2026.
//

import Foundation
import Observation

@MainActor
@Observable
final class TonightViewModel {

    /// TMDB discover en fazla 500 sayfa döndürür.
    static let maxTMDBPage = 500
    /// Uygun aday bulunamazsa denenecek farklı rastgele sayfa sayısı.
    static let maxPageAttempts = 3

    private let service: TonightServiceProtocol
    private let detailService: MovieDetailServiceProtocol
    private let filterStore: TonightFilterStoreProtocol
    private let randomPage: (ClosedRange<Int>) -> Int
    private let pickMovie: ([Movie]) -> Movie?

    private var watchListRepository: WatchlistRepositoryProtocol?

    private(set) var filters: DiscoverFilters
    private(set) var genres: [Genre] = []

    private(set) var movie: Movie?
    private(set) var detail: MovieDetailResponse?
    private(set) var directorName: String?
    private(set) var isLoadingDetail = false
    private(set) var detailFailed = false

    private(set) var watchStatus: MovieWatchStatus?
    private(set) var isFavorite = false

    private(set) var isLoading = false
    private(set) var errorMessage: String?
    private(set) var isEmptyResult = false

    /// Bu oturumda gösterilmiş filmler; filtre değişince sıfırlanır.
    private var seenIDs: Set<Int> = []
    /// Mevcut filtre seti için toplam sayfa sayısı (500 ile sınırlı).
    private var cachedTotalPages: Int?
    private var hasLoadedInitially = false

    var canPerformActions: Bool {
        detail != nil && watchListRepository != nil && !isLoading
    }

    init(
        service: TonightServiceProtocol,
        detailService: MovieDetailServiceProtocol,
        filterStore: TonightFilterStoreProtocol,
        randomPage: @escaping (ClosedRange<Int>) -> Int = { Int.random(in: $0) },
        pickMovie: @escaping ([Movie]) -> Movie? = { $0.randomElement() }
    ) {
        self.service = service
        self.detailService = detailService
        self.filterStore = filterStore
        self.randomPage = randomPage
        self.pickMovie = pickMovie
        self.filters = filterStore.load()
    }

    func configure(watchListRepository: WatchlistRepositoryProtocol) {
        self.watchListRepository = watchListRepository
    }

    // MARK: Loading

    func loadInitial() async {
        guard !hasLoadedInitially else {
            refreshLibraryStatus()
            return
        }
        hasLoadedInitially = true

        async let genresTask: Void = loadGenresIfNeeded()
        await suggestAnother()
        await genresTask
    }

    func loadGenresIfNeeded() async {
        guard genres.isEmpty else { return }
        if let fetched = try? await service.fetchGenres() {
            genres = fetched.sorted { $0.name < $1.name }
        }
    }

    func suggestAnother() async {
        guard !isLoading else { return }

        isLoading = true
        errorMessage = nil
        isEmptyResult = false

        defer {
            isLoading = false
        }

        do {
            if let next = try await findRandomMovie() {
                show(next)
                await loadDetail(for: next.id)
            } else {
                clearCurrentMovie()
                isEmptyResult = true
            }
        } catch {
            clearCurrentMovie()
            errorMessage = error.localizedDescription
        }
    }

    func reloadDetail() async {
        guard let movie else { return }
        await loadDetail(for: movie.id)
    }

    // MARK: Filters

    func applyFilters(_ newFilters: DiscoverFilters) async {
        filters = newFilters
        filterStore.save(newFilters)
        seenIDs.removeAll()
        cachedTotalPages = nil
        await suggestAnother()
    }

    func resetFilters() async {
        await applyFilters(.none)
    }

    // MARK: Library actions

    func setWatchStatus(_ status: MovieWatchStatus) async {
        guard let detail, let watchListRepository else { return }

        let newStatus: MovieWatchStatus? = watchStatus == status ? nil : status

        watchListRepository.setStatus(newStatus, for: detail, directorName: directorName)
        refreshLibraryStatus()

        // İzlenen film artık önerilmeyeceği için hemen yenisine geç.
        if newStatus == .watched {
            await suggestAnother()
        }
    }

    func toggleFavorite() {
        guard let detail, let watchListRepository else { return }

        watchListRepository.setFavorite(!isFavorite, for: detail, directorName: directorName)
        refreshLibraryStatus()
    }

    func refreshLibraryStatus() {
        guard let movie, let watchListRepository else {
            watchStatus = nil
            isFavorite = false
            return
        }

        watchStatus = watchListRepository.status(for: movie.id)
        isFavorite = watchListRepository.isFavorite(id: movie.id)
    }

    // MARK: Private

    private func findRandomMovie() async throws -> Movie? {
        let excludedIDs = watchedIDs().union(seenIDs)
        var firstPage: TrendingMoviesResponse?

        if cachedTotalPages == nil {
            let response = try await service.discoverMovies(filters: filters, page: 1)
            cachedTotalPages = min(response.totalPages, Self.maxTMDBPage)
            firstPage = response
        }

        guard let totalPages = cachedTotalPages, totalPages > 0 else {
            return nil
        }

        for page in pagesToTry(totalPages: totalPages) {
            let response: TrendingMoviesResponse
            if page == 1, let firstPage {
                response = firstPage
            } else {
                response = try await service.discoverMovies(filters: filters, page: page)
            }

            let candidates = response.results.filter {
                $0.posterPath != nil && !excludedIDs.contains($0.id)
            }

            if let picked = pickMovie(candidates) {
                return picked
            }
        }

        return nil
    }

    /// Az sayfa varsa hepsi, yoksa `maxPageAttempts` kadar farklı rastgele sayfa.
    private func pagesToTry(totalPages: Int) -> [Int] {
        if totalPages <= Self.maxPageAttempts {
            return Array(1...totalPages).shuffled()
        }

        var pages: [Int] = []
        var draws = 0
        while pages.count < Self.maxPageAttempts && draws < Self.maxPageAttempts * 10 {
            let page = randomPage(1...totalPages)
            if !pages.contains(page) {
                pages.append(page)
            }
            draws += 1
        }
        return pages
    }

    private func watchedIDs() -> Set<Int> {
        Set(watchListRepository?.fetchWatched().map(\.id) ?? [])
    }

    private func show(_ movie: Movie) {
        self.movie = movie
        seenIDs.insert(movie.id)
        detail = nil
        directorName = nil
        detailFailed = false
        refreshLibraryStatus()
    }

    private func clearCurrentMovie() {
        movie = nil
        detail = nil
        directorName = nil
        detailFailed = false
        refreshLibraryStatus()
    }

    private func loadDetail(for id: Int) async {
        isLoadingDetail = true
        detailFailed = false

        defer {
            isLoadingDetail = false
        }

        async let detailResponse = detailService.fetchMovieDetail(id: id)
        async let creditsResponse = detailService.fetchCredits(id: id)

        do {
            let loadedDetail = try await detailResponse
            let credits = try? await creditsResponse

            // Bu arada başka film önerildiyse eski sonucu yok say.
            guard movie?.id == id else { return }

            detail = loadedDetail
            directorName = credits?.directorName
        } catch {
            guard movie?.id == id else { return }
            detailFailed = true
        }
    }
}
