//
//  GenreDistributionChart.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 24.11.2026.
//

import SwiftUI

struct GenreDistributionChart: View {
    let data: [GenreBucket]

    private let genreColors: [Color] = [
        .blue, .purple, .orange, .pink, .cyan, .mint, .indigo, .teal
    ]

    var body: some View {
        TopItemsBarChart(
            title: "Top Genres",
            systemImage: "theatermasks.fill",
            items: data.prefix(8).map { BarChartItem(label: $0.genre, count: $0.count) },
            colors: genreColors
        )
    }
}

#Preview {
    GenreDistributionChart(data: [
        GenreBucket(genre: "Action", count: 12),
        GenreBucket(genre: "Drama", count: 8),
        GenreBucket(genre: "Comedy", count: 6),
        GenreBucket(genre: "Sci-Fi", count: 4),
        GenreBucket(genre: "Horror", count: 3)
    ])
    .padding()
}
