//
//  StatCard.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 24.11.2026.
//

import SwiftUI

struct StatCard: View {
    let title: String
    let value: String
    let subtitle: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(color)
                    .frame(width: 30, height: 30)
                    .background(color.opacity(0.15))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                
                Spacer()
            }
            
            Text(value)
                .font(.title2.weight(.bold))
                .foregroundStyle(.primary)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.primary)
                
                if !subtitle.isEmpty {
                    Text(subtitle)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.secondarySystemBackground))
        )
    }
}

#Preview {
    HStack {
        StatCard(title: "Watched", value: "42", subtitle: "movies", icon: "film.fill", color: .blue)
        StatCard(title: "Watch Time", value: "86h 30m", subtitle: "total", icon: "clock.fill", color: .purple)
    }
    .padding()
}
