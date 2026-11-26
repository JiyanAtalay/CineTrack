//
//  TonightMovieCard.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 26.11.2026.
//

import SwiftUI

struct TonightMovieCard: View {

    let movie: Movie
    let detail: MovieDetailResponse?
    let isLoadingDetail: Bool
    let detailFailed: Bool
    /// nil = poster ekranda kalan boşluğu doldurur; değer verilirse sabit yükseklik kullanılır
    /// (overview açıkken poster büyümesin diye).
    let fixedPosterHeight: CGFloat?
    let isOverviewExpanded: Bool
    let onTap: () -> Void
    let onRetryDetail: () -> Void
    let onToggleOverview: () -> Void
    let onPosterHeightChange: (CGFloat) -> Void

    private static let collapsedOverviewLines = 3

    @State private var fullOverviewHeight: CGFloat = 0
    @State private var collapsedOverviewHeight: CGFloat = 0

    private var isOverviewTruncated: Bool {
        fullOverviewHeight > collapsedOverviewHeight + 1
    }

    var body: some View {
        VStack(spacing: 12) {
            Button(action: onTap) {
                VStack(spacing: 12) {
                    poster

                    VStack(spacing: 4) {
                        Text(movie.title)
                            .font(.title2.bold())
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                            .minimumScaleFactor(0.8)

                        metaRow
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.horizontal)
                }
            }
            .buttonStyle(.plain)

            if let detail, !detail.genres.isEmpty {
                GenreSectionView(genres: detail.genres)
            }

            if detailFailed {
                Button("Couldn't load details. Retry", systemImage: "arrow.clockwise", action: onRetryDetail)
                    .font(.footnote)
            }

            if !movie.overview.isEmpty {
                overview
            }
        }
    }

    // MARK: Poster

    private var poster: some View {
        Color.clear
            .aspectRatio(2 / 3, contentMode: .fit)
            .overlay {
                CachedAsyncImage(url: movie.posterURL) {
                    ImagePlaceholderView()
                }
                .scaledToFill()
            }
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(color: .black.opacity(0.25), radius: 16, y: 8)
            .onGeometryChange(for: CGFloat.self) { proxy in
                proxy.size.height
            } action: { height in
                onPosterHeightChange(height)
            }
            .frame(height: fixedPosterHeight)
            .frame(maxHeight: fixedPosterHeight == nil ? .infinity : nil)
            .padding(.horizontal, 32)
    }

    // MARK: Overview

    private var overview: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(movie.overview)
                .font(.callout)
                .foregroundStyle(.secondary)
                .lineLimit(isOverviewExpanded ? nil : Self.collapsedOverviewLines)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, alignment: .leading)
                .onGeometryChange(for: CGFloat.self) { proxy in
                    proxy.size.height
                } action: { height in
                    if !isOverviewExpanded {
                        collapsedOverviewHeight = height
                    }
                }
                // Kesilip kesilmediğini anlamak için metnin tam halini görünmez şekilde ölç.
                .background(alignment: .top) {
                    Text(movie.overview)
                        .font(.callout)
                        .fixedSize(horizontal: false, vertical: true)
                        .hidden()
                        .onGeometryChange(for: CGFloat.self) { proxy in
                            proxy.size.height
                        } action: { height in
                            fullOverviewHeight = height
                        }
                }

            if isOverviewTruncated || isOverviewExpanded {
                Button(isOverviewExpanded ? "Show less" : "Read more", action: onToggleOverview)
                    .font(.footnote.weight(.semibold))
            }
        }
        .padding(.horizontal)
    }

    // MARK: Meta

    private var metaRow: some View {
        HStack(spacing: 8) {
            if !movie.releaseYear.isEmpty {
                Text(movie.releaseYear)
            }

            Label(movie.ratingText, systemImage: "star.fill")
                .labelStyle(.titleAndIcon)

            if let detail, detail.runtime != nil {
                Text(detail.runtimeText)
            } else if isLoadingDetail {
                ProgressView()
                    .controlSize(.mini)
            }
        }
    }
}
