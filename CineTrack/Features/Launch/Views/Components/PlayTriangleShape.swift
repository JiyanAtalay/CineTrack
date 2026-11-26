//
//  PlayTriangleShape.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 26.11.2026.
//

import SwiftUI

/// Logodaki oynat üçgeninin iç (köşeleri yuvarlanmadan önceki) hali.
/// Yuvarlak köşeler için `BrandMarkView.triangleCornerRadius * 2` genişliğinde, `.round` birleşimli stroke ile birlikte çizilir.
/// Noktalar LaunchMark görseliyle birebir aynıdır; statik launch screen'den geçiş kaymasız olur.
nonisolated struct PlayTriangleShape: Shape {
    func path(in rect: CGRect) -> Path {
        let scale = min(rect.width, rect.height) / BrandMarkView.designSize
        let center = CGPoint(x: rect.midX, y: rect.midY)

        func point(_ x: CGFloat, _ y: CGFloat) -> CGPoint {
            CGPoint(x: center.x + x * scale, y: center.y + y * scale)
        }

        var path = Path()
        path.move(to: point(-53.04, -98.04))
        path.addLine(to: point(-53.04, 98.04))
        path.addLine(to: point(112.08, 0))
        path.closeSubpath()
        return path
    }
}
