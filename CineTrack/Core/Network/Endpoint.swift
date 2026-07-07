//
//  Endpoint.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 14.06.2026.
//

import Foundation

protocol Endpoint {
    var path: String { get }
    var method: HTTPMethod { get }
    var queryItems: [URLQueryItem] { get }
}
