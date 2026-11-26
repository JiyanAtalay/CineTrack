//
//  LaunchSplashView.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 26.11.2026.
//

import SwiftUI

/// Statik launch screen'in hemen ardından gösterilen kısa açılış animasyonu.
/// İlk karesi launch screen ile aynıdır (arka plan + ortada oynat üçgeni); ardından film şeritleri
/// iki yandan kayarak gelir, "C" yayı çizilir ve logo hafifçe "zıplar".
/// Bitişte logo izleyiciye doğru büyüyüp kaybolur, şeritler çıkar ve ortadan açılan bir iris
/// alttaki içeriği ortaya çıkarır. İris açılmaya başlarken `onReveal`, tamamen açılınca `onFinished` çağrılır.
struct LaunchSplashView: View {
    var onReveal: () -> Void = {}
    var onFinished: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    @State private var stripProgress: CGFloat = 0
    @State private var stripExitProgress: CGFloat = 0
    @State private var arcProgress: CGFloat = 0
    @State private var isHaloVisible = false
    @State private var markScale: CGFloat = 1
    @State private var markOpacity: Double = 1
    @State private var irisProgress: CGFloat = 0

    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let stripOffsetY = geometry.size.height * 0.24
            let irisMaxDiameter = hypot(geometry.size.width, geometry.size.height) * 1.05

            ZStack {
                backdrop(width: width, stripOffsetY: stripOffsetY)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .mask {
                        ZStack {
                            Rectangle()
                            Circle()
                                .frame(width: irisMaxDiameter * irisProgress, height: irisMaxDiameter * irisProgress)
                                .blendMode(.destinationOut)
                        }
                        .compositingGroup()
                    }

                // Logo iris maskesinin dışında: açılan deliğin üstünden öne doğru uçarak kaybolur.
                Group {
                    Circle()
                        .fill(Color(.brandGold).opacity(0.12))
                        .frame(width: BrandMarkView.launchSize * 1.45, height: BrandMarkView.launchSize * 1.45)
                        .scaleEffect(isHaloVisible ? 1 : 0.6)
                        .opacity(isHaloVisible ? 1 : 0)

                    BrandMarkView(arcProgress: arcProgress)
                }
                .compositingGroup() // solarken katmanlar tek parça gibi saydamlaşsın
                .scaleEffect(markScale)
                .opacity(markOpacity)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .ignoresSafeArea()
        .task { await runAnimation() }
    }

    /// Arka plan ve film şeritleri; bitişte iris bu katmanı açar.
    private func backdrop(width: CGFloat, stripOffsetY: CGFloat) -> some View {
        ZStack {
            Color(.launchBackground)

            FilmStripView()
                .frame(width: width * 2)
                .offset(
                    x: interpolate(from: width * 1.5, to: -width * 0.1) - width * 1.6 * stripExitProgress,
                    y: -stripOffsetY
                )

            FilmStripView()
                .frame(width: width * 2)
                .offset(
                    x: interpolate(from: -width * 1.5, to: width * 0.1) + width * 1.6 * stripExitProgress,
                    y: stripOffsetY
                )
        }
    }

    private func interpolate(from start: CGFloat, to end: CGFloat) -> CGFloat {
        start + (end - start) * stripProgress
    }

    private func runAnimation() async {
        if reduceMotion {
            arcProgress = 1
            stripProgress = 1
            isHaloVisible = true
            try? await Task.sleep(for: .milliseconds(500))
            onReveal()
            onFinished()
            return
        }

        // Giriş
        withAnimation(.easeOut(duration: 1.1)) { stripProgress = 1 }
        withAnimation(.easeInOut(duration: 0.75).delay(0.1)) { arcProgress = 1 }
        withAnimation(.easeOut(duration: 0.6).delay(0.35)) { isHaloVisible = true }

        try? await Task.sleep(for: .milliseconds(850))
        withAnimation(.spring(response: 0.25, dampingFraction: 0.5)) { markScale = 1.08 }

        try? await Task.sleep(for: .milliseconds(150))
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) { markScale = 1 }

        try? await Task.sleep(for: .milliseconds(300))

        // Bitiş: logo öne uçar, şeritler çıkar, iris açılır
        withAnimation(.easeIn(duration: 0.35)) {
            markScale = 1.9
            markOpacity = 0
        }
        withAnimation(.easeIn(duration: 0.4)) { stripExitProgress = 1 }
        withAnimation(.easeIn(duration: 0.55).delay(0.05)) { irisProgress = 1 }
        onReveal()

        try? await Task.sleep(for: .milliseconds(620))
        onFinished()
    }
}

#Preview {
    LaunchSplashView(onFinished: {})
}
