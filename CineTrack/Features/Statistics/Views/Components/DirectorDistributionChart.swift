//
//  DirectorDistributionChart.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 25.11.2026.
//

import SwiftUI

struct DirectorDistributionChart: View {
    let data: [DirectorBucket]

    private let directorColors: [Color] = [
        .orange, .red, .pink, .purple, .indigo
    ]

    var body: some View {
        TopItemsBarChart(
            title: "Favorite Directors",
            systemImage: "megaphone.fill",
            items: data
                .prefix(StatisticsViewModel.topDirectorLimit)
                .map { BarChartItem(label: $0.name, count: $0.count) },
            colors: directorColors
        )
    }
}

#Preview {
    DirectorDistributionChart(data: [
        DirectorBucket(name: "Christopher Nolan", count: 6),
        DirectorBucket(name: "Denis Villeneuve", count: 4),
        DirectorBucket(name: "Quentin Tarantino", count: 3),
        DirectorBucket(name: "Greta Gerwig", count: 2),
        DirectorBucket(name: "Bong Joon-ho", count: 1)
    ])
    .padding()
}
