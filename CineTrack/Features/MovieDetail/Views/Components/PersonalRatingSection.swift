//
//  PersonalRatingSection.swift
//  CineTrack
//
//  Created by Mehmet Jiyan Atalay on 19.11.2026.
//

import SwiftUI

struct PersonalRatingSection: View {
    @Binding var selectedRating: Int
    @Binding var reviewText: String
    
    let hasExistingRating: Bool
    let isSaving: Bool
    let errorMessage: String?
    
    let onSave: () async -> Bool
    let onDelete: () -> Void
    
    @State private var isEditing = false
    
    private var shouldShowEditor: Bool {
        !hasExistingRating || isEditing
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            if shouldShowEditor {
                editorSection
            } else {
                ratingSummarySection
            }
            if let errorMessage {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundStyle(.red)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.secondarySystemBackground))
        )
        .onChange(of: hasExistingRating) { _, newValue in
            if newValue {
                isEditing = false
            }
        }
    }
        
    private var ratingSummarySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Your Rating")
                    .font(.headline)
                
                Spacer()
                
                HStack(spacing: 10) { circularButton(icon: "pencil", color: .blue) {
                        isEditing = true
                    }
                    circularButton(icon: "trash", color: .red, action: onDelete)
                }
            }
            
            HStack(spacing: 4) {
                ForEach(1...5, id: \.self) { star in
                    Image(systemName: star <= selectedRating ? "star.fill" : "star")
                    .foregroundStyle(
                        star <= selectedRating ? .yellow : .gray
                    )
                    .font(.system(size: 18))
                }
                
                Text("\(selectedRating)/5")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .padding(.leading, 5)
            }
            
            if !reviewText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                Text(reviewText)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
        
    private var editorSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(hasExistingRating ? "Update Your Rating" : "Rate This Movie")
                .font(.headline)
            
            HStack(spacing: 8) {
                ForEach(1...5, id: \.self) { star in
                    Button {
                        selectedRating = star
                    } label: {
                        Image(systemName: star <= selectedRating ? "star.fill" : "star")
                        .font(.system(size: 22))
                        .foregroundStyle(
                            star <= selectedRating ? .yellow : .gray
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
            
            TextEditor(text: $reviewText)
                .font(.subheadline)
                .frame(height: 75)
                .scrollContentBackground(.hidden)
                .padding(8)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(.tertiarySystemBackground))
                )
                .overlay(alignment: .topLeading) {
                    if reviewText.isEmpty {
                        Text("Write your thoughts about this movie...")
                            .font(.subheadline)
                            .foregroundStyle(.tertiary)
                            .padding(.horizontal, 13)
                            .padding(.vertical, 16)
                            .allowsHitTesting(false)
                    }
                }
            
            HStack {
                if hasExistingRating {
                    Button("Cancel") {
                        isEditing = false
                    }
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                Button {
                    Task {
                        let success = await onSave()
                        if success {
                            isEditing = false
                        }
                    }
                } label: {
                    HStack(spacing: 6) {
                        if isSaving {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Image(systemName: "checkmark")
                        }
                        
                        Text(hasExistingRating ? "Update" : "Save")
                    }
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 9)
                    .background(
                        Capsule()
                            .fill(Color.accentColor)
                    )
                }
                .disabled(selectedRating == 0 || isSaving)
            }
        }
    }
        
    private func circularButton(icon: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(color)
                .frame(width: 34, height: 34)
                .background(color.opacity(0.12))
                .clipShape(Circle())
        }
        .buttonStyle(.plain)
    }
}
