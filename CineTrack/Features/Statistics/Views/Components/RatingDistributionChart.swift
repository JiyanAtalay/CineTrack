//
//  RatingDistributionChart.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 24.11.2026.
//

import SwiftUI
import Charts

struct RatingDistributionChart: View {
    let data: [RatingBucket]
    
    private var maxCount: Int {
        data.map(\.count).max() ?? 1
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Label("Rating Distribution", systemImage: "star.fill")
                .font(.headline)
            
            Chart(data) { bucket in
                BarMark(
                    x: .value("Rating", bucket.label),
                    y: .value("Count", bucket.count)
                )
                .foregroundStyle(barColor(for: bucket.rating))
                .cornerRadius(6)
                .annotation(position: .top, spacing: 4) {
                    if bucket.count > 0 {
                        Text("\(bucket.count)")
                            .font(.caption2.weight(.semibold))
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .chartYAxis {
                AxisMarks(values: .automatic(desiredCount: 4)) { value in
                    AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5, dash: [4]))
                        .foregroundStyle(Color.secondary.opacity(0.3))
                    AxisValueLabel()
                        .foregroundStyle(.secondary)
                }
            }
            .chartXAxis {
                AxisMarks { value in
                    AxisValueLabel()
                        .foregroundStyle(.primary)
                }
            }
            .chartYScale(domain: 0...(Double(maxCount) * 1.25))
            .frame(height: 200)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.secondarySystemBackground))
        )
    }
    
    private func barColor(for rating: Int) -> Color {
        switch rating {
        case 1: return .red
        case 2: return .orange
        case 3: return .yellow
        case 4: return .mint
        case 5: return .green
        default: return .gray
        }
    }
}

#Preview {
    RatingDistributionChart(data: [
        RatingBucket(rating: 1, count: 2),
        RatingBucket(rating: 2, count: 1),
        RatingBucket(rating: 3, count: 5),
        RatingBucket(rating: 4, count: 8),
        RatingBucket(rating: 5, count: 3)
    ])
    .padding()
}
