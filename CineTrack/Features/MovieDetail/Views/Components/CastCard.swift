//
//  CastCard.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 3.07.2026.
//

import Foundation
import SwiftUI

struct CastCard: View {
    
    let cast: Cast
    
    var body: some View {
        VStack(spacing: 8) {
            CachedAsyncImage(url: cast.profileURL) {
                Image(systemName: "person.fill")
                    .resizable()
                    .scaledToFit()
                    .padding(18)
                    .foregroundStyle(.secondary)
            }
            .scaledToFill()
            .frame(width: 80, height: 80)
            .background(.gray.opacity(0.15))
            .clipShape(Circle())
            
            Text(cast.name)
                .font(.caption.bold())
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .frame(height: 32, alignment: .top)
            
            Text(cast.character)
                .font(.caption2)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .frame(height: 32, alignment: .top)
            
            .lineLimit(2)
        }
        .frame(width: 90)
    }
}
