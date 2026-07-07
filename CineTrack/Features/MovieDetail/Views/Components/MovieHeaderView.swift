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
                }
                .padding(.top, 12)

                Spacer()
            }
            .padding(.horizontal)
            .padding(.bottom, -40)
        }
    }
}
