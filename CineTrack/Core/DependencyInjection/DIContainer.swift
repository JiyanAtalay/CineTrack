//
//  DIContainer.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 4.07.2026.
//

import Foundation
import SwiftData

@MainActor
final class DIContainer {
    static let shared = DIContainer()
    
    private init() {}
    
    // MARK: Services
    
    lazy var networkService: NetworkServiceProtocol = NetworkService()
    lazy var movieService: MovieServiceProtocol = MovieService(networkService: networkService)
    lazy var movieDetailService: MovieDetailServiceProtocol = MovieDetailService(networkService: networkService)
    lazy var searchService: SearchServiceProtocol = SearchService(networkService: networkService)
    lazy var personService: PersonServiceProtocol = PersonService(networkService: networkService)
    lazy var tonightService: TonightServiceProtocol = TonightService(networkService: networkService)
    
    // MARK: ViewModels
    
    func makeHomeViewModel() -> HomeViewModel {
        HomeViewModel(movieService: movieService)
    }
    
    func makeMovieDetailViewModel() -> MovieDetailViewModel {
        MovieDetailViewModel(service: movieDetailService)
    }
    
    func makeSearchViewModel() -> SearchViewModel {
        SearchViewModel(searchService: searchService)
    }
    
    func makePersonDetailViewModel() -> PersonDetailViewModel {
        PersonDetailViewModel(service: personService)
    }
    
    func makeTonightViewModel() -> TonightViewModel {
        TonightViewModel(
            service: tonightService,
            detailService: movieDetailService,
            filterStore: UserDefaultsTonightFilterStore()
        )
    }
    
    func makePersonalMovieRatingRepository(context: ModelContext ) -> PersonalMovieRatingRepositoryProtocol {
        PersonalMovieRatingRepository(context: context)
    }
}
