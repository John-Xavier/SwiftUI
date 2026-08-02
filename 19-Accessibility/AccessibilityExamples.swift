//
//  AccessibilityExamples.swift
//  Labels, values, traits, hints, grouping, and hiding decorative views.
//

import SwiftUI

struct AccessibilityExamples: View {
    @State private var isFavorite = false
    @State private var volume = 0.7

    var body: some View {
        List {
            // MARK: 1. Icon-only button NEEDS a label (VoiceOver reads "Delete, button").
            Button { } label: {
                Image(systemName: "trash")
            }
            .accessibilityLabel("Delete")
            .accessibilityHint("Removes this item permanently")

            // MARK: 2. A toggle-like control with a value + trait.
            Button {
                isFavorite.toggle()
            } label: {
                Image(systemName: isFavorite ? "heart.fill" : "heart")
            }
            .accessibilityLabel("Favorite")
            // Announce state so it isn't just "Favorite, button".
            .accessibilityValue(isFavorite ? "On" : "Off")
            .accessibilityAddTraits(isFavorite ? [.isButton, .isSelected] : .isButton)

            // MARK: 3. Combine a row so VoiceOver reads it as ONE element.
            HStack {
                Image(systemName: "star.fill")
                    .accessibilityHidden(true)          // decorative → hide it
                VStack(alignment: .leading) {
                    Text("Pro Plan")
                    Text("$9.99 / month").foregroundStyle(.secondary)
                }
            }
            // Without this, VoiceOver stops on the icon, then title, then price separately.
            .accessibilityElement(children: .combine)   // reads "Pro Plan, $9.99 per month"

            // MARK: 4. A custom slider with a spoken percentage value.
            VStack(alignment: .leading) {
                Text("Volume")
                Slider(value: $volume, in: 0...1)
            }
            .accessibilityElement(children: .combine)
            .accessibilityValue("\(Int(volume * 100)) percent")

            // MARK: 5. Mark a header for rotor navigation.
            Text("Settings")
                .font(.title2.bold())
                .accessibilityAddTraits(.isHeader)
        }
    }
}

#Preview {
    AccessibilityExamples()
}
