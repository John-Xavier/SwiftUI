//
//  CustomViewModifier.swift
//  A reusable ViewModifier plus a convenient .cardStyle() extension.
//

import SwiftUI

/// A card look: padding, material background, rounded corners, subtle shadow.
///
/// Encapsulating this in a ViewModifier means you change the app's card style
/// in ONE place.
struct CardStyle: ViewModifier {
    var cornerRadius: CGFloat = 12

    func body(content: Content) -> some View {
        content
            .padding()
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: cornerRadius))
            .shadow(color: .black.opacity(0.1), radius: 8, y: 4)
    }
}

// The `.cardStyle()` sugar so call sites read naturally.
extension View {
    func cardStyle(cornerRadius: CGFloat = 12) -> some View {
        modifier(CardStyle(cornerRadius: cornerRadius))
    }
}

// A parameterized modifier example: a colored "pill" tag.
struct PillStyle: ViewModifier {
    var color: Color
    func body(content: Content) -> some View {
        content
            .font(.caption.bold())
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(color.opacity(0.2), in: Capsule())
            .foregroundStyle(color)
    }
}

extension View {
    func pill(_ color: Color) -> some View { modifier(PillStyle(color: color)) }
}

#Preview {
    VStack(spacing: 20) {
        VStack(alignment: .leading) {
            Text("Card Title").font(.headline)
            Text("Reusable card style applied with .cardStyle()")
                .foregroundStyle(.secondary)
        }
        .cardStyle()

        HStack {
            Text("New").pill(.blue)
            Text("Sale").pill(.red)
            Text("Hot").pill(.orange)
        }
    }
    .padding()
}
