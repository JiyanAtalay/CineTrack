//
//  CastSectionView.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 3.07.2026.
//

import Foundation
import SwiftUI

struct CastSectionView: View {
    
    let cast: [Cast]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Cast")
                .font(.title3.bold())
                .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 16) {
                    ForEach(cast) { actor in
                        CastCard(cast: actor)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}
