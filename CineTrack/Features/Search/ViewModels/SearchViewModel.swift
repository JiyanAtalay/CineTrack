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
    var errorMessage: String?
    
    private var searchTask: Task<Void, Never>?
    
    init(searchService: SearchServiceProtocol) {
        self.searchService = searchService
    }
    
    func search() async {
        guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            movies = []
            currentPage = 1
            totalPages = 1
            return
        }
        
        currentPage = 1
        isLoading = true
        
        defer {
            isLoading = false
        }
        
        do {
            let response = try await searchService.searchMovie(query: query, page: 1)
            
            movies = response.results
            totalPages = response.totalPages
            
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func searchWithDebounce() {
        searchTask?.cancel()
        
        searchTask = Task {
            try? await Task.sleep(for: .milliseconds(500))
            
            guard !Task.isCancelled else { return }
            
            await search()
        }
    }
    
    func loadNextPageIfNeeded(currentMovie: Movie) async {
        guard let lastMovie = movies.last else { return }
        
        guard lastMovie.id == currentMovie.id else { return }
        
        guard currentPage < totalPages else { return }
        
        currentPage = 1
        
        do {
            
            let response = try await searchService.searchMovie(query: query, page: currentPage)
            
            movies.append(contentsOf: response.results)
            
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
