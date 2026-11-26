//
//  BrandMarkView.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 26.11.2026.
//

import SwiftUI

/// CineTrack logosu: altın "C" yayı ve içinde beyaz oynat üçgeni.
/// `arcProgress` 0...1 arasında yayın ne kadarının çizildiğini belirler.
struct BrandMarkView: View {
    /// İkon tasarımının birim ölçüsü (1024 × 1024).
    nonisolated static let designSize: CGFloat = 1024
    /// Launch screen'deki LaunchMark görselinin nokta (pt) boyutu; ikisi aynı kalmalı.
    static let launchSize: CGFloat = 180

    var arcProgress: CGFloat = 1
    var size: CGFloat = BrandMarkView.launchSize

    private var scale: CGFloat { size / Self.designSize }

    var body: some View {
        ZStack {
            BrandArcShape()
                .trim(from: 0, to: arcProgress)
                .stroke(
                    Color(.brandGold),
                    style: StrokeStyle(lineWidth: 118 * scale, lineCap: .round)
                )

            PlayTriangleShape()
                .fill(.white)
                .overlay {
                    PlayTriangleShape()
                        .stroke(.white, style: StrokeStyle(lineWidth: 52 * scale, lineJoin: .round))
                }
        }
        .frame(width: size, height: size)
        .accessibilityHidden(true)
    }
}

#Preview {
    BrandMarkView()
        .padding()
        .background(Color(.launchBackground))
}
