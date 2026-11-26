//
//  PersonHeaderView.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 25.11.2026.
//

import Foundation
import SwiftUI

struct PersonHeaderView: View {

    let person: PersonDetailResponse

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            CachedAsyncImage(url: person.profileURL) {
                Image(systemName: "person.fill")
                    .resizable()
                    .scaledToFit()
                    .padding(28)
                    .foregroundStyle(.secondary)
            }
            .scaledToFill()
            .frame(width: 120, height: 120)
            .background(.gray.opacity(0.15))
            .clipShape(Circle())

            VStack(alignment: .leading, spacing: 6) {
                Text(person.name)
                    .font(.title.bold())

                if let department = person.knownForDepartment, !department.isEmpty {
                    Text(department)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.secondary)
                }

                if let lifeSpanText = person.lifeSpanText {
                    Label(lifeSpanText, systemImage: "calendar")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                if let placeOfBirthText = person.placeOfBirthText {
                    Label(placeOfBirthText, systemImage: "mappin.and.ellipse")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
            }
            .padding(.top, 8)

            Spacer(minLength: 0)
        }
        .padding(.horizontal)
    }
}
