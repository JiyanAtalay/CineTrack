//
//  ImagePlaceholderView.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 4.07.2026.
//

import Foundation
import SwiftUI

struct ImagePlaceholderView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(.gray.opacity(0.15))
            ProgressView()
        }
    }
}
