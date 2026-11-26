//
//  StatisticsViewModelTests.swift
//  CineTrackTests
//
//  Created by Mehmet Jiyan Atalay on 25.11.2026.
//

import Testing
import SwiftData
@testable import CineTrack

@Suite("StatisticsViewModel Tests")
struct StatisticsViewModelTests {

    @MainActor
    private func makeContainer() throws -> ModelContainer {
        try ModelContainer(
            for: WatchlistMovie.self, PersonalMovieRating.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
    }

    @MainActor
    private func insertMovie(
        _ context: ModelContext,
        id: Int,
        director: String?,
        status: MovieWatchStatus? = .watched
    ) {
        context.insert(
            WatchlistMovie(
                id: id,
                title: "Movie \(id)",
                posterPath: nil,
                backdropPath: nil,
                releaseDate: nil,
                voteAverage: 7,
                watchStatus: status?.rawValue,
                directorName: director
            )
        )
    }

    @Test("Director distribution counts only watched movies with a director")
    @MainActor
    func directorDistributionFiltersMovies() throws {
        let container = try makeContainer()
        let context = container.mainContext

        insertMovie(context, id: 1, director: "Christopher Nolan")
        insertMovie(context, id: 2, director: "Christopher Nolan")
        insertMovie(context, id: 3, director: "Denis Villeneuve")
        insertMovie(context, id: 4, director: nil)
        insertMovie(context, id: 5, director: "Greta Gerwig", status: .planned)
        insertMovie(context, id: 6, director: "Christopher Nolan", status: .planned)
        try context.save()

        let viewModel = StatisticsViewModel()
        viewModel.load(context: context)

        #expect(viewModel.directorDistribution.map(\.name) == ["Christopher Nolan", "Denis Villeneuve"])
        #expect(viewModel.directorDistribution.map(\.count) == [2, 1])
    }

    @Test("Director distribution is limited to top 5, sorted by count then name")
    @MainActor
    func directorDistributionTopFive() throws {
        let container = try makeContainer()
        let context = container.mainContext

        var id = 0
        let counts: [(String, Int)] = [
            ("Zack Snyder", 1),
            ("Ari Aster", 1),
            ("Bong Joon-ho", 2),
            ("Christopher Nolan", 4),
            ("Denis Villeneuve", 3),
            ("Greta Gerwig", 1),
            ("Jordan Peele", 1)
        ]
        for (director, count) in counts {
            for _ in 0..<count {
                id += 1
                insertMovie(context, id: id, director: director)
            }
        }
        try context.save()

        let viewModel = StatisticsViewModel()
        viewModel.load(context: context)

        #expect(viewModel.directorDistribution.count == 5)
        #expect(viewModel.directorDistribution.map(\.name) == [
            "Christopher Nolan",
            "Denis Villeneuve",
            "Bong Joon-ho",
            "Ari Aster",
            "Greta Gerwig"
        ])
    }

    @Test("Director distribution is empty when no director info exists")
    @MainActor
    func directorDistributionEmpty() throws {
        let container = try makeContainer()
        let context = container.mainContext

        insertMovie(context, id: 1, director: nil)
        try context.save()

        let viewModel = StatisticsViewModel()
        viewModel.load(context: context)

        #expect(viewModel.directorDistribution.isEmpty)
    }
}
