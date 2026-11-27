//
//  ErrorStateView.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 27.11.2026.
//

import SwiftUI

/// Tam ekran hata durumu; `onRetry` verilirse "Try Again" butonu gösterir.
struct ErrorStateView: View {

    var title: String = "Something Went Wrong"
    let message: String
    var systemImage: String = "wifi.exclamationmark"
    var onRetry: (() async -> Void)?

    @State private var isRetrying = false

    var body: some View {
        ContentUnavailableView {
            Label(title, systemImage: systemImage)
        } description: {
            Text(message)
        } actions: {
            if let onRetry {
                Button {
                    Task {
                        isRetrying = true
                        await onRetry()
                        isRetrying = false
                    }
                } label: {
                    Label("Try Again", systemImage: "arrow.clockwise")
                }
                .buttonStyle(.borderedProminent)
                .disabled(isRetrying)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    ErrorStateView(
        message: "You're offline. Check your internet connection and try again.",
        onRetry: {}
    )
}
