//
//  HomeViewModel.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 15.06.2026.
//

import Foundation

@MainActor
@Observable
final class HomeViewModel {
    
    private let movieService: MovieServiceProtocol
    
    private(set) var trendingMovies: [Movie] = []
    private(set) var populerMovies: [Movie] = []
    private(set) var topRatedMovies: [Movie] = []
    
    var isLoading: Bool = false
    
    var errorMessage: String?

    /// İlk yükleme bitti mi (başarılı ya da hatalı); boş durumu ilk açılıştaki anlık durumdan ayırır.
    private(set) var hasLoaded = false

    var hasContent: Bool {
        !trendingMovies.isEmpty || !populerMovies.isEmpty || !topRatedMovies.isEmpty
    }

    init(movieService: MovieServiceProtocol) {
        self.movieService = movieService
    }

    func fetchHomeData() async {

        isLoading = true
        errorMessage = nil

        defer {
            isLoading = false
        }
        
        do {
            
            async let trending = movieService.fetchTrendingMovies()
            async let populer = movieService.fetchPopularMovies()
            async let topRated = movieService.fetchTopRatedMovies()
            
            trendingMovies = try await trending
            populerMovies = try await populer
            topRatedMovies = try await topRated
            hasLoaded = true

        } catch {
            guard !error.isCancellation else { return }
            errorMessage = error.localizedDescription
            hasLoaded = true
        }
    }
}
