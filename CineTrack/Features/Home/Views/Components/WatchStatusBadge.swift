//
//  WatchStatusBadge.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 23.11.2026.
//

import SwiftUI

struct WatchStatusBadge: View {
    let status: MovieWatchStatus

    private var icon: String {
        switch status {
        case .planned:
            return "clock.fill"
        case .watched:
            return "checkmark.circle.fill"
        }
    }

    private var badgeColor: Color {
        switch status {
        case .planned:
            return .blue
        case .watched:
            return .green
        }
    }

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 9, weight: .bold))

            Text(status.title)
                .font(.system(size: 9, weight: .semibold))
        }
        .foregroundStyle(.white)
        .padding(.horizontal, 6)
        .padding(.vertical, 4)
        .background(badgeColor.gradient, in: Capsule())
        .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
    }
}

#Preview {
    VStack(spacing: 16) {
        WatchStatusBadge(status: .planned)
        WatchStatusBadge(status: .watched)
    }
}
