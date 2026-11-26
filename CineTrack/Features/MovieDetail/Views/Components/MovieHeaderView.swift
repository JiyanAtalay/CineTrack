//
//  MovieHeaderView.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 2.07.2026.
//

import Foundation
import SwiftUI

struct MovieHeaderView: View {

    let movie: MovieDetailResponse
    var directors: [CrewMember] = []
    var onDirectorTap: (CrewMember) -> Void = { _ in }

    private static let personURLScheme = "cinetrack-person"

    var body: some View {
        VStack(spacing: 0) {
            CachedAsyncImage(url: movie.backdropURL) {
                ImagePlaceholderView()
            }
            .scaledToFill()
            .frame(height: 240)
            .frame(maxWidth: .infinity)
            .clipped()

            HStack(alignment: .top, spacing: 16) {
                CachedAsyncImage(url: movie.posterURL) {
                    ImagePlaceholderView()
                }
                .scaledToFill()
                .frame(width: 120, height: 180)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(radius: 8)
                .offset(y: -60)

                VStack(alignment: .leading, spacing: 8) {
                    Text(movie.title)
                        .font(.title.bold())

                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundStyle(.yellow)

                        Text(movie.ratingText)

                        Text("•")

                        Text(movie.runtimeText)

                        Text("•")

                        Text(movie.releaseYear)
                    }
                    .foregroundStyle(.secondary)

                    if !directors.isEmpty {
                        Label {
                            Text(directedByText)
                                .tint(.primary)
                                .environment(\.openURL, OpenURLAction { url in
                                    handleDirectorLink(url)
                                })
                        } icon: {
                            Image(systemName: "megaphone.fill")
                        }
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                    }
                }
                .padding(.top, 12)

                Spacer()
            }
            .padding(.horizontal)
            .padding(.bottom, -40)
        }
    }

    // Her yönetmen adı ayrı bir link; görünüm eski "Directed by" satırıyla aynı kalır
    private var directedByText: AttributedString {
        var result = AttributedString("Directed by ")

        for (index, director) in directors.enumerated() {
            if index > 0 {
                result += AttributedString(index == directors.count - 1 ? " & " : ", ")
            }

            var name = AttributedString(director.name)
            name.link = URL(string: "\(Self.personURLScheme)://\(director.id)")
            name.swiftUI.font = .subheadline.weight(.semibold)
            name.swiftUI.foregroundColor = .primary
            result += name
        }

        return result
    }

    private func handleDirectorLink(_ url: URL) -> OpenURLAction.Result {
        guard url.scheme == Self.personURLScheme,
              let id = url.host().flatMap(Int.init),
              let director = directors.first(where: { $0.id == id }) else {
            return .systemAction
        }

        onDirectorTap(director)
        return .handled
    }
}
