//
//  GenreSectionView.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 2.07.2026.
//

import Foundation
import SwiftUI

struct GenreSectionView: View {
    
    let genres: [Genre]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(genres) { genre in
                    GenreChip(genre: genre)
                }
            }
            .padding(.horizontal)
        }
    }
}
