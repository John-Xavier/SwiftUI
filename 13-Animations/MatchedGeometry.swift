//
//  MatchedGeometry.swift
//  Hero animation: morph a view between two layouts with matchedGeometryEffect.
//

import SwiftUI

struct MatchedGeometryExample: View {
    // A namespace ties the two views together so SwiftUI knows they're "the same".
    @Namespace private var animation
    @State private var isExpanded = false

    var body: some View {
        ZStack {
            if !isExpanded {
                // Collapsed: a small thumbnail.
                RoundedRectangle(cornerRadius: 12)
                    .fill(.purple.gradient)
                    // Same id + namespace as the expanded version → SwiftUI morphs between them.
                    .matchedGeometryEffect(id: "hero", in: animation)
                    .frame(width: 120, height: 120)
                    .onTapGesture {
                        withAnimation(.spring(duration: 0.5)) { isExpanded = true }
                    }
            } else {
                // Expanded: full-screen.
                RoundedRectangle(cornerRadius: 0)
                    .fill(.purple.gradient)
                    .matchedGeometryEffect(id: "hero", in: animation)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.spring(duration: 0.5)) { isExpanded = false }
                    }
                    .overlay(Text("Tap to collapse").foregroundStyle(.white))
            }
        }
    }
}

#Preview {
    MatchedGeometryExample()
}
