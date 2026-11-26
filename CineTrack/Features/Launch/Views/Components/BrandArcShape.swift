//
//  BrandArcShape.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 26.11.2026.
//

import SwiftUI

/// Logodaki "C" yayı. Geometri, uygulama ikonuyla aynı 1024 birimlik tasarım ölçüsünden ölçeklenir.
/// Yol sağ üstten başlayıp sola dolanarak sağ altta biter; `trim` ile "çizilerek" belirebilir.
nonisolated struct BrandArcShape: Shape {
    func path(in rect: CGRect) -> Path {
        let scale = min(rect.width, rect.height) / BrandMarkView.designSize
        let center = CGPoint(x: rect.midX, y: rect.midY)

        var path = Path()
        path.addArc(
            center: center,
            radius: 290 * scale,
            startAngle: .degrees(320),
            endAngle: .degrees(40),
            clockwise: true
        )
        return path
    }
}
