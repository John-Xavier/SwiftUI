//
//  ViewExtensions.swift
//  Handy View extensions used across many projects.
//

import SwiftUI

extension View {

    /// Conditionally apply a modifier.
    ///
    /// Usage: `Text("Hi").if(isBold) { $0.bold() }`
    ///
    /// ⚠️ Because the two branches produce different view types, avoid this for
    /// structural changes that hold state — it can reset animations/state.
    /// Great for simple, cosmetic tweaks.
    @ViewBuilder
    func `if`<Transform: View>(
        _ condition: Bool,
        transform: (Self) -> Transform
    ) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }

    /// Hide or show a view while keeping its layout space (unlike a plain `if`).
    @ViewBuilder
    func hidden(_ shouldHide: Bool) -> some View {
        if shouldHide { self.hidden() } else { self }
    }

    /// Erase to AnyView. Use only when you truly need type erasure — it disables
    /// some SwiftUI optimizations.
    func eraseToAnyView() -> AnyView { AnyView(self) }
}

// MARK: - Rounded corners on SPECIFIC corners (UIKit-backed)

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

extension View {
    /// Round only the corners you name: `.cornerRadius(12, corners: [.topLeft, .topRight])`
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

#Preview {
    VStack(spacing: 20) {
        Text("Bold when true")
            .if(true) { $0.bold().foregroundStyle(.blue) }

        Color.green
            .frame(height: 80)
            .cornerRadius(20, corners: [.topLeft, .bottomRight])
    }
    .padding()
}
