//
//  LoadingStateView.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 27.11.2026.
//

import SwiftUI

/// Tam ekran yükleme durumu; isteğe bağlı kısa bir açıklama gösterir.
struct LoadingStateView: View {

    var message: String?

    var body: some View {
        VStack(spacing: 14) {
            ProgressView()
                .controlSize(.large)

            if let message {
                Text(message)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(message ?? "Loading")
    }
}

#Preview {
    LoadingStateView(message: "Loading movies…")
}
