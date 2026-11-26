//
//  TonightTabIcon.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 26.11.2026.
//

import UIKit

/// Ortadaki Tonight tab'ı için vurgulu ikon: dolu daire içinde beyaz zar.
/// `.alwaysOriginal` sayesinde tab bar ikonu template olarak boyamaz ve diğer tablardan ayrışır.
enum TonightTabIcon {
    static let diameter: CGFloat = 32

    static let image: UIImage = {
        let size = CGSize(width: diameter, height: diameter)
        let renderer = UIGraphicsImageRenderer(size: size)

        let rendered = renderer.image { _ in
            let circleColor = UIColor(named: "AccentColor") ?? .systemBlue
            circleColor.setFill()
            UIBezierPath(ovalIn: CGRect(origin: .zero, size: size)).fill()

            let configuration = UIImage.SymbolConfiguration(pointSize: diameter * 0.48, weight: .bold)
            guard let symbol = UIImage(systemName: "dice.fill", withConfiguration: configuration)?
                .withTintColor(.white, renderingMode: .alwaysOriginal) else {
                return
            }

            let origin = CGPoint(
                x: (size.width - symbol.size.width) / 2,
                y: (size.height - symbol.size.height) / 2
            )
            symbol.draw(in: CGRect(origin: origin, size: symbol.size))
        }

        return rendered.withRenderingMode(.alwaysOriginal)
    }()
}
