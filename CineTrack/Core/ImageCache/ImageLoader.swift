//
//  ImageLoader.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 4.07.2026.
//

import Foundation
import SwiftUI

@MainActor
@Observable
final class ImageLoader {
    var image: UIImage?
    
    func load(from url: URL) async {
        if let cached = await ImageCache.shared.image(for: url) {
            image = cached
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            guard let image = UIImage(data: data) else { return }
            
            await ImageCache.shared.insert(image, for: url)
            
            self.image = image
        } catch {
            print(error.localizedDescription)
        }
    }
}
