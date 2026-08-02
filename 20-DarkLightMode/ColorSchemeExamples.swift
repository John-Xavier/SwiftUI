//
//  ColorSchemeExamples.swift
//  Semantic colors, reading the scheme, per-view overrides, previewing both.
//

import SwiftUI

struct ColorSchemeExamples: View {
    // Read the ACTIVE appearance to make fine adjustments.
    @Environment(\.colorScheme) private var colorScheme

    // Example: a shadow needs to be stronger in dark mode to stay visible.
    private var shadowOpacity: Double {
        colorScheme == .dark ? 0.5 : 0.15
    }

    var body: some View {
        VStack(spacing: 20) {

            // 1. Semantic text colors — adapt automatically.
            VStack(alignment: .leading) {
                Text("Primary title").foregroundStyle(.primary)
                Text("Secondary subtitle").foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            // Semantic background — light gray in light mode, dark gray in dark mode.
            .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 12))

            // 2. A "card" using systemBackground + an adaptive shadow.
            Text("Adaptive card")
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(.systemBackground), in: RoundedRectangle(cornerRadius: 12))
                .shadow(color: .black.opacity(shadowOpacity), radius: 8, y: 4)

            // 3. A brand color from the asset catalog (Any + Dark variants).
            //    Falls back gracefully if the color set doesn't exist yet.
            Text("Brand")
                .padding()
                .background(Color("BrandPrimary"))   // define this as a Color Set
                .foregroundStyle(.white)
                .clipShape(Capsule())

            Text("Current scheme: \(colorScheme == .dark ? "Dark" : "Light")")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
    }
}

// Preview BOTH appearances side by side so you catch issues early.
#Preview("Light") {
    ColorSchemeExamples().preferredColorScheme(.light)
}
#Preview("Dark") {
    ColorSchemeExamples().preferredColorScheme(.dark)
}
