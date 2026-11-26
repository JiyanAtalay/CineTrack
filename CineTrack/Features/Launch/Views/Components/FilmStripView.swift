//
//  FilmStripView.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 26.11.2026.
//

import SwiftUI

/// Yatay film şeridi: üstte ve altta delik sıraları, ortada kare çerçeveleri.
struct FilmStripView: View {
    static let height: CGFloat = 46

    private let stripColor = Color(red: 0x22 / 255, green: 0x22 / 255, blue: 0x25 / 255)
    private let frameColor = Color(red: 0x1A / 255, green: 0x1A / 255, blue: 0x1D / 255)

    var body: some View {
        Canvas { context, size in
            context.fill(Path(CGRect(origin: .zero, size: size)), with: .color(stripColor))

            let hole = CGSize(width: 10, height: 7)
            let holeSpacing: CGFloat = 20
            let holeInset: CGFloat = 5
            var x: CGFloat = 5
            while x < size.width {
                for y in [holeInset, size.height - holeInset - hole.height] {
                    let rect = CGRect(origin: CGPoint(x: x, y: y), size: hole)
                    context.fill(Path(roundedRect: rect, cornerRadius: 2), with: .color(Color(.launchBackground)))
                }
                x += holeSpacing
            }

            let frameTop = holeInset * 2 + hole.height
            let frameHeight = size.height - frameTop * 2
            let frameWidth: CGFloat = 44
            let frameGap: CGFloat = 6
            x = 0
            while x < size.width {
                let rect = CGRect(x: x, y: frameTop, width: frameWidth, height: frameHeight)
                context.fill(Path(roundedRect: rect, cornerRadius: 3), with: .color(frameColor))
                x += frameWidth + frameGap
            }
        }
        .frame(height: Self.height)
        .accessibilityHidden(true)
    }
}

#Preview {
    FilmStripView()
        .background(Color(.launchBackground))
}
