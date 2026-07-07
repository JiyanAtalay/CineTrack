//
//  CachedAsyncImage.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 4.07.2026.
//

import Foundation
import SwiftUI

struct CachedAsyncImage<Placeholder: View>: View {
    let url: URL?
    
    @State private var loader = ImageLoader()
    @ViewBuilder let placeholder: () -> Placeholder
    
    var body: some View {
        Group {
            if let image = loader.image {
                Image(uiImage: image)
                    .resizable()
            } else {
                placeholder()
            }
        }
        .task(id: url) {
            guard let url else { return }
            
            await loader.load(from: url)
        }
    }
}
