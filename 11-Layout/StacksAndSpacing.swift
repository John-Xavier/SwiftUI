//
//  StacksAndSpacing.swift
//  VStack / HStack / ZStack, Spacer, alignment, and padding.
//

import SwiftUI

struct StacksAndSpacing: View {
    var body: some View {
        VStack(spacing: 24) {

            // MARK: HStack with a Spacer pushing items to the edges
            HStack {
                Text("Left")
                Spacer()          // flexible gap → pushes the two texts apart
                Text("Right")
            }
            .padding()
            .background(.quaternary, in: RoundedRectangle(cornerRadius: 8))

            // MARK: VStack with leading alignment
            VStack(alignment: .leading, spacing: 4) {
                Text("Title").font(.headline)
                Text("Subtitle aligned to the leading edge")
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)   // stretch + left-align

            // MARK: ZStack layering (background + foreground)
            ZStack(alignment: .bottomTrailing) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.blue.gradient)
                    .frame(height: 100)
                Text("Badge")
                    .padding(6)
                    .background(.white, in: Capsule())
                    .padding(8)                                // inset from the corner
            }

            // MARK: fixed vs flexible frames
            HStack(spacing: 12) {
                Color.red.frame(width: 40, height: 40)          // fixed
                Color.green.frame(maxWidth: .infinity, maxHeight: 40) // grows to fill
                Color.blue.frame(width: 40, height: 40)
            }
        }
        .padding()
    }
}

#Preview {
    StacksAndSpacing()
}
