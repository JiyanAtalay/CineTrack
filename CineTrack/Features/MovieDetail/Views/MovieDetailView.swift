//
//  MovieDetailView.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 2.07.2026.
//

import Foundation
import SwiftUI
import SwiftData

struct MovieDetailView: View {
    @Environment(\.modelContext) private var modelContext
    
    let movieId: Int
    
    @State private var viewModel: MovieDetailViewModel = DIContainer.shared.makeMovieDetailViewModel()
    @State private var selectedPerson: PersonRoute?
    
    init(movieId: Int) {
        self.movieId = movieId
    }
    
    var body: some View {
        Group {
            if let movie = viewModel.movie {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        MovieHeaderView(movie: movie, directors: viewModel.directors) { director in
                            selectedPerson = PersonRoute(id: director.id, name: director.name, role: .directing)
                        }
                        MovieActionButtons(movie: movie, trailerURL: viewModel.trailerURL, watchStatus: viewModel.watchStatus, isFavorite: viewModel.isFavorite, onWatchStatusChange: { status in
                                viewModel.setWatchStatus(status)
                            }, onToggleFavorite: {
                                viewModel.toggleFavorite()
                            }
                        )
                        GenreSectionView(genres: movie.genres)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Overview")
                                .font(.title3.bold())
                            
                            Text(movie.overview)
                        }
                        .padding(.horizontal)
                        
                        if !viewModel.cast.isEmpty {
                            CastSectionView(cast: viewModel.cast)
                        }
                        
                        PersonalRatingSection(
                            selectedRating: $viewModel.selectedRating,
                            reviewText: $viewModel.reviewText,
                            hasExistingRating: viewModel.personalRating != nil,
                            isSaving: viewModel.isSavingRating,
                            errorMessage: viewModel.ratingErrorMessage,
                            onSave: {
                                await viewModel.savePersonalRating()
                            },
                            onDelete: {
                                viewModel.deletePersonalRating()
                            }
                        )
                        .padding(.horizontal)
                        
                        if !viewModel.similarMovies.isEmpty {
                            SimilarMoviesSectionView(movies: viewModel.similarMovies)
                        }
                    }
                }
            } else if let errorMessage = viewModel.errorMessage {
                ErrorStateView(
                    title: "Couldn't Load Movie",
                    message: errorMessage,
                    onRetry: { await viewModel.loadMovie(id: movieId) }
                )
            } else {
                LoadingStateView()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        .navigationDestination(item: $selectedPerson) { person in
            PersonDetailView(route: person)
        }
        .task {
            
            viewModel.configure(watchListRepository: WatchlistRepository(context: modelContext))
            viewModel.configure(personalRatingRepository: DIContainer.shared
                .makePersonalMovieRatingRepository(context: modelContext))
            
            await viewModel.loadMovie(id: movieId)
        }
    }
}
