//
//  ImageCacheTests.swift
//  CineTrackTests
//
//  Created by Mehmet Jiyan Atalay on 6.07.2026.
//

import Testing
import UIKit
@testable import CineTrack

@Suite("Image Cache Tests")
struct ImageCacheTests {
    @Test("Image cache stores image")
    func cacheStoresImage() async throws {
        let url = URL(string: "https://test.com/image.jpg")!
        let image = UIImage(systemName: "star")!

        await ImageCache.shared.insert(image, for: url)

        let cached = await ImageCache.shared.image(for: url)

        #expect(cached != nil)
    }
    
    @Test("Cache returns same image")
    func cacheReturnsSameImage() async throws {
        let url = URL(string: "https://apple.com")!
        let image = UIImage(systemName: "star")!

        await ImageCache.shared.insert(image, for: url)

        let cached = await ImageCache.shared.image(for: url)

        #expect(cached === image)
    }
}
