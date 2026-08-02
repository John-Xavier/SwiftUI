//
//  Transitions.swift
//  Animate views being added / removed.
//

import SwiftUI

struct TransitionExamples: View {
    @State private var showBanner = false
    @State private var showCard = false

    var body: some View {
        VStack(spacing: 20) {
            Button("Toggle banner") {
                // Transitions only animate when the insert/remove happens inside withAnimation.
                withAnimation(.easeInOut) { showBanner.toggle() }
            }

            if showBanner {
                Text("New message!")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.yellow, in: RoundedRectangle(cornerRadius: 8))
                    // Slides in from the top edge, fades while moving.
                    .transition(.move(edge: .top).combined(with: .opacity))
            }

            Divider()

            Button("Toggle card") {
                withAnimation(.spring) { showCard.toggle() }
            }

            if showCard {
                RoundedRectangle(cornerRadius: 16)
                    .fill(.blue.gradient)
                    .frame(height: 120)
                    // Different animations for appearing vs disappearing.
                    .transition(.asymmetric(
                        insertion: .scale.combined(with: .opacity),
                        removal: .opacity
                    ))
            }

            Spacer()
        }
        .padding()
    }
}

#Preview {
    TransitionExamples()
}
