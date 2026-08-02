//
//  GeometryAndAdaptive.swift
//  GeometryReader, ViewThatFits, and size classes.
//

import SwiftUI

// MARK: - GeometryReader: read the available size
//
// Use sparingly — it takes ALL offered space. Great for proportional sizing.

struct GeometryExample: View {
    var body: some View {
        GeometryReader { geo in
            VStack {
                Text("Width: \(Int(geo.size.width))")
                // Make a bar 50% of the available width.
                Rectangle()
                    .fill(.blue)
                    .frame(width: geo.size.width * 0.5, height: 20)
            }
        }
        .frame(height: 60)
    }
}

// MARK: - ViewThatFits: pick the first layout that fits
//
// Tries each child in order and renders the first one that fits the space.
// Perfect for "horizontal on wide screens, vertical on narrow".

struct AdaptiveButtons: View {
    var body: some View {
        ViewThatFits {
            // Preferred: side by side.
            HStack { buttons }
            // Fallback when there isn't enough width: stacked.
            VStack { buttons }
        }
        .padding()
    }

    private var buttons: some View {
        Group {
            Button("Cancel") {}.buttonStyle(.bordered)
            Button("Confirm") {}.buttonStyle(.borderedProminent)
        }
    }
}

// MARK: - Size classes: branch iPhone vs iPad / portrait vs landscape

struct SizeClassExample: View {
    // .compact (most iPhones portrait) vs .regular (iPad, iPhone landscape).
    @Environment(\.horizontalSizeClass) private var hSize

    var body: some View {
        if hSize == .regular {
            HStack { sidebar; detail }      // wide: side-by-side
        } else {
            VStack { sidebar; detail }      // narrow: stacked
        }
    }

    private var sidebar: some View { Color.blue.opacity(0.2).overlay(Text("Sidebar")) }
    private var detail:  some View { Color.green.opacity(0.2).overlay(Text("Detail")) }
}

#Preview("Geometry")  { GeometryExample().padding() }
#Preview("ViewThatFits") { AdaptiveButtons() }
#Preview("SizeClass") { SizeClassExample() }
