//
//  PersonDetailResponse.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 25.11.2026.
//

import Foundation

struct PersonDetailResponse: Decodable, Sendable {
    let id: Int
    let name: String
    let biography: String
    let birthday: String?
    let deathday: String?
    let placeOfBirth: String?
    let profilePath: String?
    let knownForDepartment: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case biography
        case birthday
        case deathday
        case placeOfBirth = "place_of_birth"
        case profilePath = "profile_path"
        case knownForDepartment = "known_for_department"
    }

    init(
        id: Int,
        name: String,
        biography: String = "",
        birthday: String? = nil,
        deathday: String? = nil,
        placeOfBirth: String? = nil,
        profilePath: String? = nil,
        knownForDepartment: String? = nil
    ) {
        self.id = id
        self.name = name
        self.biography = biography
        self.birthday = birthday
        self.deathday = deathday
        self.placeOfBirth = placeOfBirth
        self.profilePath = profilePath
        self.knownForDepartment = knownForDepartment
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        // TMDB biyografi alanını bazen null gönderebiliyor
        biography = try container.decodeIfPresent(String.self, forKey: .biography) ?? ""
        birthday = try container.decodeIfPresent(String.self, forKey: .birthday)
        deathday = try container.decodeIfPresent(String.self, forKey: .deathday)
        placeOfBirth = try container.decodeIfPresent(String.self, forKey: .placeOfBirth)
        profilePath = try container.decodeIfPresent(String.self, forKey: .profilePath)
        knownForDepartment = try container.decodeIfPresent(String.self, forKey: .knownForDepartment)
    }

    /// Aynı kişi bilgisini farklı bir biyografi ile döndürür (dil fallback'i için).
    func withBiography(_ biography: String) -> PersonDetailResponse {
        PersonDetailResponse(
            id: id,
            name: name,
            biography: biography,
            birthday: birthday,
            deathday: deathday,
            placeOfBirth: placeOfBirth,
            profilePath: profilePath,
            knownForDepartment: knownForDepartment
        )
    }
}
