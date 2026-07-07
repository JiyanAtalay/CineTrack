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
    
    private(set) var movie: MovieDetailResponse?
    private(set) var trailerURL: URL?
    private(set) var cast: [Cast] = []
    private(set) var similarMovies: [Movie] = []
    
    private var watchListRepository: WatchlistRepositoryProtocol?
    private(set) var isInWatchlist = false
    
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
            async let castResponse = service.fetchCast(id: id)
            async let similar = service.fetchSimilarMovies(id: id)
            
            movie = try await detail
            checkWatchlist()
            trailerURL = try await trailer
            cast = try await castResponse
            similarMovies = try await similar
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func configure(watchListRepository: WatchlistRepositoryProtocol) {
        self.watchListRepository = watchListRepository
    }
    
    func toggleWatchList() {
        guard let movie else { return }
        
        if isInWatchlist {
            watchListRepository?.remove(id: movie.id)
        } else {
            watchListRepository?.add(movie: movie)
        }
        
        checkWatchlist()
    }
    
    func checkWatchlist() {
        guard let movie else { return }
        isInWatchlist = watchListRepository?.contains(id: movie.id) ?? false
    }
}
