//
//  CreditsResponse.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 3.07.2026.
//

import Foundation

struct CrewMember: Identifiable, Decodable, Sendable {
    let id: Int
    let name: String
    let job: String
    let profilePath: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, job
        case profilePath = "profile_path"
    }
}

struct CreditsResponse: Decodable, Sendable {
    let cast: [Cast]
    let crew: [CrewMember]
    
    var directors: [CrewMember] {
        crew.filter { $0.job == "Director" }
    }
    
    var directorName: String? {
        directors.first?.name
    }
}
