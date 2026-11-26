//
//  TopItemsBarChart.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 25.11.2026.
//

import SwiftUI
import Charts

struct BarChartItem: Identifiable {
    let label: String
    let count: Int
    var id: String { label }
}

/// Horizontal bar chart card used for "top N" style statistics (genres, directors...).
struct TopItemsBarChart: View {
    let title: String
    let systemImage: String
    let items: [BarChartItem]
    let colors: [Color]

    // Her satırda isim + çubuk alt alta durur; yazı boyutu büyüdükçe satır da büyür
    @ScaledMetric(relativeTo: .caption) private var rowHeight: CGFloat = 56
    private let barHeight: CGFloat = 16

    private var maxCount: Int {
        items.map(\.count).max() ?? 1
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Label(title, systemImage: systemImage)
                .font(.headline)

            Chart(Array(items.enumerated()), id: \.element.id) { index, item in
                BarMark(
                    x: .value("Count", item.count),
                    y: .value("Name", item.label),
                    height: .fixed(barHeight)
                )
                .foregroundStyle(colors.isEmpty ? .gray : colors[index % colors.count])
                .cornerRadius(6)
                .annotation(position: .top, alignment: .leading, spacing: 4) {
                    Text(item.label)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.primary)
                        .lineLimit(1)
                }
                .annotation(position: .trailing, spacing: 6) {
                    Text("\(item.count)")
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(.secondary)
                }
            }
            .chartXAxis {
                AxisMarks(values: .automatic(desiredCount: 4)) { _ in
                    AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5, dash: [4]))
                        .foregroundStyle(Color.secondary.opacity(0.3))
                    AxisValueLabel()
                        .foregroundStyle(.secondary)
                }
            }
            // İsimler çubukların üstünde annotation olarak çiziliyor; eksen etiketleri
            // uzun isimlerde çubukların üstüne taşıp çakışıyordu
            .chartYAxis(.hidden)
            .chartXScale(domain: 0...(Double(maxCount) * 1.3))
            .frame(height: CGFloat(items.count) * rowHeight + 24)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.secondarySystemBackground))
        )
    }
}
