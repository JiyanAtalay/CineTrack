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
    
    init(movieService: MovieServiceProtocol) {
        self.movieService = movieService
    }
    
    func fetchHomeData() async {
        
        isLoading = true
        
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
            
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
