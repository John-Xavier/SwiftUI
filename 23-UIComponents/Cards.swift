//
//  Cards.swift
//  The most-used card layouts.
//
//  A "card" is just content on a rounded, elevated background. Use semantic
//  colors so cards look right in light and dark mode.
//

import SwiftUI

// MARK: - 1. Basic card (reusable container)
//
// Wrap ANY content in a card look. `@ViewBuilder` lets callers pass their own body.

struct Card<Content: View>: View {
    @ViewBuilder var content: Content

    var body: some View {
        content
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 16))
            .shadow(color: .black.opacity(0.08), radius: 8, y: 4)
    }
}

// MARK: - 2. Info card (title + subtitle + optional icon)

struct InfoCard: View {
    let icon: String
    let title: String
    let subtitle: String

    var body: some View {
        Card {
            HStack(spacing: 14) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(.white)
                    .frame(width: 44, height: 44)
                    .background(.blue.gradient, in: RoundedRectangle(cornerRadius: 10))

                VStack(alignment: .leading, spacing: 2) {
                    Text(title).font(.headline)
                    Text(subtitle).font(.subheadline).foregroundStyle(.secondary)
                }
            }
        }
    }
}

// MARK: - 3. Image card (photo header + caption) — common in feeds

struct ImageCard: View {
    let systemImage: String   // swap for a real Image / AsyncImage
    let title: String
    let body_: String

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header image.
            Image(systemName: systemImage)
                .font(.system(size: 60))
                .frame(maxWidth: .infinity)
                .frame(height: 140)
                .background(.blue.gradient)
                .foregroundStyle(.white)

            // Text block.
            VStack(alignment: .leading, spacing: 6) {
                Text(title).font(.headline)
                Text(body_).font(.subheadline).foregroundStyle(.secondary)
            }
            .padding()
        }
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))   // clips the image corners too
        .shadow(color: .black.opacity(0.08), radius: 8, y: 4)
    }
}

// MARK: - Preview

#Preview {
    ScrollView {
        VStack(spacing: 16) {
            InfoCard(icon: "bolt.fill", title: "Fast", subtitle: "Loads in milliseconds")
            ImageCard(systemImage: "photo", title: "Mountains", body_: "A calm morning above the clouds.")
            Card { Text("Any content you want, in a card.") }
        }
        .padding()
    }
    .background(Color(.systemGroupedBackground))
}
