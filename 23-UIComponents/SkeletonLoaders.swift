//
//  SkeletonLoaders.swift
//  Shimmering placeholder content shown while data loads.
//
//  A skeleton is a gray outline of the UI that "shimmers" until real data
//  arrives — it feels faster than a spinner and avoids layout jumps.
//

import SwiftUI

// MARK: - 1. The shimmer effect (a reusable modifier)
//
// It sweeps a light gradient across whatever it's applied to.

struct Shimmer: ViewModifier {
    @State private var phase: CGFloat = -1

    func body(content: Content) -> some View {
        content
            .overlay {
                GeometryReader { geo in
                    LinearGradient(
                        colors: [.clear, .white.opacity(0.5), .clear],
                        startPoint: .leading, endPoint: .trailing
                    )
                    .frame(width: geo.size.width)
                    .offset(x: phase * geo.size.width * 2)   // sweep across
                }
                .mask(content)                                // only shimmer the shape
            }
            .onAppear {
                withAnimation(.linear(duration: 1.2).repeatForever(autoreverses: false)) {
                    phase = 1
                }
            }
    }
}

extension View {
    /// Add a repeating shimmer sweep — apply to your gray placeholder shapes.
    func shimmering() -> some View { modifier(Shimmer()) }
}

// MARK: - 2. Placeholder building blocks

/// A gray rounded rectangle used as a placeholder for text/images.
struct SkeletonBox: View {
    var width: CGFloat? = nil
    var height: CGFloat

    var body: some View {
        RoundedRectangle(cornerRadius: 6)
            .fill(Color(.systemGray5))
            .frame(width: width, height: height)
            .shimmering()
    }
}

// MARK: - 3. A skeleton row (matches your real row's shape)

struct SkeletonRow: View {
    var body: some View {
        HStack(spacing: 12) {
            Circle().fill(Color(.systemGray5)).frame(width: 44, height: 44).shimmering()
            VStack(alignment: .leading, spacing: 8) {
                SkeletonBox(width: 160, height: 12)
                SkeletonBox(width: 100, height: 12)
            }
            Spacer()
        }
        .padding(.vertical, 6)
    }
}

// MARK: - 4. Usage: show skeletons while `isLoading`

struct SkeletonListExample: View {
    @State private var isLoading = true
    @State private var users = User.sampleList

    var body: some View {
        List {
            if isLoading {
                // Show a handful of skeleton rows as a preview of the real content.
                ForEach(0..<6, id: \.self) { _ in SkeletonRow() }
            } else {
                ForEach(users) { user in
                    HStack(spacing: 12) {
                        Circle().fill(.blue.opacity(0.3)).frame(width: 44, height: 44)
                        Text(user.fullName)
                    }
                }
            }
        }
        .task {
            // Simulate a network delay, then reveal the data.
            try? await Task.sleep(for: .seconds(2))
            isLoading = false
        }
    }
}

#Preview {
    SkeletonListExample()
}
