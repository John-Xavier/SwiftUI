//
//  ColorAndStringExtensions.swift
//  Color(hex:) and common String helpers.
//

import SwiftUI

// MARK: - Color from a hex string
//
// Designers give you "#FF8800", not RGB doubles. This init parses it.

extension Color {
    /// Create a Color from a hex string. Accepts "#RGB", "#RRGGBB", or "#RRGGBBAA".
    init(hex: String) {
        // Strip non-hex characters (#, spaces).
        let hexString = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&int)

        let a, r, g, b: UInt64
        switch hexString.count {
        case 3:  // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:  // RRGGBB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:  // RRGGBBAA (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default: // Fallback to black on bad input.
            (a, r, g, b) = (255, 0, 0, 0)
        }

        self.init(
            .sRGB,
            red:   Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - String helpers

extension String {
    /// Whitespace/newline-trimmed copy.
    var trimmed: String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// True if the string is empty after trimming (i.e. "just spaces" counts as blank).
    var isBlank: Bool { trimmed.isEmpty }

    /// A lightweight email check. For production, prefer a proper validator, but
    /// this covers the common "looks like an email" case.
    var isValidEmail: Bool {
        let pattern = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        return range(of: pattern, options: .regularExpression) != nil
    }
}

#Preview {
    VStack(spacing: 12) {
        Color(hex: "#FF8800").frame(height: 40)
        Color(hex: "3498db").frame(height: 40)
        Text("  Padded  ".trimmed + " ← trimmed")
        Text("john@example.com".isValidEmail ? "valid ✅" : "invalid ❌")
    }
    .padding()
}
