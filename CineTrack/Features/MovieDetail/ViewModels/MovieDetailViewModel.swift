//
//  MovieDetailViewModel.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 2.07.2026.
//

import Foundation
import Observation

@MainActor
@Observable
final class MovieDetailViewModel {
    private let service: MovieDetailServiceProtocol
    private var personalRatingRepository: PersonalMovieRatingRepositoryProtocol?
    
    private(set) var movie: MovieDetailResponse?
    private(set) var personalRating: PersonalMovieRating?
    private(set) var trailerURL: URL?
    private(set) var cast: [Cast] = []
    private(set) var directors: [CrewMember] = []
    var directorName: String? {
        directors.first?.name
    }
    private(set) var similarMovies: [Movie] = []
    
    private var watchListRepository: WatchlistRepositoryProtocol?
    private(set) var watchStatus: MovieWatchStatus?
    private(set) var isFavorite = false
    
    var selectedRating: Int = 0
    var reviewText: String = ""
    var isSavingRating = false
    var ratingErrorMessage: String?
    
    var isLoading = false
    var errorMessage: String?
    
    init(service: MovieDetailServiceProtocol) {
        self.service = service
    }
    
    func loadMovie(id: Int) async {
        isLoading = true
        
        defer {
            isLoading = false
        }
        
        do {
            async let detail = service.fetchMovieDetail(id: id)
            async let trailer = service.fetchTrailer(id: id)
            async let creditsResponse = service.fetchCredits(id: id)
            async let similar = service.fetchSimilarMovies(id: id)
            
            movie = try await detail
            checkLibraryStatus()
            loadPersonalRating()
            trailerURL = try await trailer
            let credits = try await creditsResponse
            cast = Array(credits.cast.prefix(15))
            directors = credits.directors
            similarMovies = try await similar
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func configure(watchListRepository: WatchlistRepositoryProtocol) {
        self.watchListRepository = watchListRepository
    }
    
    func configure(personalRatingRepository: PersonalMovieRatingRepositoryProtocol) {
        self.personalRatingRepository = personalRatingRepository
    }
    
    func setWatchStatus(_ status: MovieWatchStatus) {
        guard let movie, let watchListRepository else { return }

        let newStatus: MovieWatchStatus? = watchStatus == status ? nil : status

        watchListRepository.setStatus(newStatus, for: movie, directorName: directorName)
        checkLibraryStatus()
    }

    func toggleFavorite() {
        guard let movie, let watchListRepository else { return }

        watchListRepository.setFavorite(!isFavorite, for: movie, directorName: directorName)
        checkLibraryStatus()
    }

    func checkLibraryStatus() {
        guard let movie, let watchListRepository else { return }

        watchStatus = watchListRepository.status(for: movie.id)
        isFavorite = watchListRepository.isFavorite(id: movie.id)
    }

    // Eski kullanımlarla uyumluluk için:
    var isInWatchlist: Bool {
        watchStatus == .planned
    }
    
    func loadPersonalRating() {
        guard let movie, let personalRatingRepository else {
            return
        }

        do {
            personalRating = try personalRatingRepository.fetch(
                movieID: movie.id
            )

            selectedRating = personalRating?.rating ?? 0
            reviewText = personalRating?.reviewText ?? ""

        } catch {
            ratingErrorMessage = error.localizedDescription
        }
    }
    
    func savePersonalRating() async -> Bool {
        guard let movie, let personalRatingRepository, (1...5).contains(selectedRating) else {
            ratingErrorMessage = "Please select a rating between 1 and 5."
            return false
        }

        isSavingRating = true
        ratingErrorMessage = nil

        defer {
            isSavingRating = false
        }

        do {
            try personalRatingRepository.save(movie: movie, rating: selectedRating, reviewText: reviewText)
            loadPersonalRating()
            return true
        } catch {
            ratingErrorMessage = error.localizedDescription
            return false
        }
    }
    
    func deletePersonalRating() {

        guard let movie,
              let personalRatingRepository else {
            return
        }

        do {
            try personalRatingRepository.delete(movieID: movie.id)

            personalRating = nil
            selectedRating = 0
            reviewText = ""
            ratingErrorMessage = nil

        } catch {
            ratingErrorMessage = error.localizedDescription
        }
    }
}
