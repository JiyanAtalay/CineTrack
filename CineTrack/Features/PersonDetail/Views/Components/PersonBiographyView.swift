//
//  PersonBiographyView.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 25.11.2026.
//

import Foundation
import SwiftUI

struct PersonBiographyView: View {

    let biography: String

    @State private var isExpanded = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Biography")
                .font(.title3.bold())

            Text(biography)
                .lineLimit(isExpanded ? nil : 4)

            Button(isExpanded ? "Show less" : "Read more") {
                withAnimation {
                    isExpanded.toggle()
                }
            }
            .font(.subheadline.weight(.semibold))
        }
        .padding(.horizontal)
    }
}
