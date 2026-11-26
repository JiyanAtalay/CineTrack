//
//  FavoriteBadge.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 23.11.2026.
//

import SwiftUI

struct FavoriteBadge: View {
    var body: some View {
        Image(systemName: "heart.fill")
            .font(.system(size: 12, weight: .bold))
            .foregroundStyle(.white)
            .padding(6)
            .background(.red.gradient, in: Circle())
            .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
    }
}

#Preview {
    FavoriteBadge()
}
