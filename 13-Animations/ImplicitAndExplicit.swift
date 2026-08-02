//
//  ImplicitAndExplicit.swift
//  .animation(_:value:) vs withAnimation { }.
//

import SwiftUI

struct AnimationBasics: View {
    @State private var isBig = false
    @State private var isRotated = false

    var body: some View {
        VStack(spacing: 40) {

            // MARK: Implicit animation
            // Attaches to the view. Animates ONLY when `isBig` changes.
            Circle()
                .fill(.blue)
                .frame(width: isBig ? 150 : 80, height: isBig ? 150 : 80)
                .animation(.spring(duration: 0.4), value: isBig)
                .onTapGesture { isBig.toggle() }   // no withAnimation needed

            // MARK: Explicit animation
            // Wrap the state change; everything affected by it animates.
            Rectangle()
                .fill(.green)
                .frame(width: 100, height: 100)
                .rotationEffect(.degrees(isRotated ? 45 : 0))
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        isRotated.toggle()
                    }
                }

            Text("Tap the shapes")
                .foregroundStyle(.secondary)
        }
        .padding()
    }
}

#Preview {
    AnimationBasics()
}
