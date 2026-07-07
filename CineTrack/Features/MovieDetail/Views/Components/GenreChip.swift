//
//  GenreChip.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 2.07.2026.
//

import Foundation
import SwiftUI

struct GenreChip: View {
    
    let genre: Genre
    
    var body: some View {
        Text(genre.name)
            .font(.caption.weight(.medium))
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(.blue.opacity(0.15))
            .clipShape(Capsule())
    }
}
