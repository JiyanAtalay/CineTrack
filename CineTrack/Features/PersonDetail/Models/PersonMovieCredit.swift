//
//  PersonMovieCredit.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 25.11.2026.
//

import Foundation

struct PersonMovieCredit: Decodable, Identifiable, Sendable {
    let id: Int
    let title: String
    let overview: String?
    let posterPath: String?
    let backdropPath: String?
    let releaseDate: String?
    let voteAverage: Double?
    let genreIDs: [Int]?
    let popularity: Double?
    let character: String?
    let job: String?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case genreIDs = "genre_ids"
        case popularity
        case character
        case job
    }

    init(
        id: Int,
        title: String,
        overview: String? = nil,
        posterPath: String? = nil,
        backdropPath: String? = nil,
        releaseDate: String? = nil,
        voteAverage: Double? = nil,
        genreIDs: [Int]? = nil,
        popularity: Double? = nil,
        character: String? = nil,
        job: String? = nil
    ) {
        self.id = id
        self.title = title
        self.overview = overview
        self.posterPath = posterPath
        self.backdropPath = backdropPath
        self.releaseDate = releaseDate
        self.voteAverage = voteAverage
        self.genreIDs = genreIDs
        self.popularity = popularity
        self.character = character
        self.job = job
    }

    /// Mevcut poster kartı ve detay ekranında kullanılabilmesi için `Movie`'ye çevirir.
    var asMovie: Movie {
        Movie(
            id: id,
            title: title,
            overview: overview ?? "",
            posterPath: posterPath,
            backdropPath: backdropPath,
            releaseDate: (releaseDate?.isEmpty ?? true) ? nil : releaseDate,
            voteAverage: voteAverage ?? 0,
            genreIDs: genreIDs ?? [],
            popularity: popularity ?? 0
        )
    }
}
