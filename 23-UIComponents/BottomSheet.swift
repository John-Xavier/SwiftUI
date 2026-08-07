//
//  BottomSheet.swift
//  A bottom sheet — the simple built-in way first, a custom overlay after.
//

import SwiftUI

// MARK: - 1. Simple: use .sheet + presentationDetents (iOS 16+)
//
// This is almost always what you want. `presentationDetents` makes the sheet
// stop at heights you choose (a fraction, a fixed height, medium, large).

struct BottomSheetSimple: View {
    @State private var showSheet = false

    var body: some View {
        Button("Show bottom sheet") { showSheet = true }
            .buttonStyle(.borderedProminent)
            .sheet(isPresented: $showSheet) {
                SheetBody()
                    // The sheet can rest at ~30% height or full height; drag between them.
                    .presentationDetents([.fraction(0.3), .large])
                    .presentationDragIndicator(.visible)   // the little grabber at the top
                    .presentationCornerRadius(24)
            }
    }
}

private struct SheetBody: View {
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        VStack(spacing: 16) {
            Text("Options").font(.headline).padding(.top)
            Button("Share") {}
            Button("Duplicate") {}
            Button("Delete", role: .destructive) {}
            Spacer()
            Button("Close") { dismiss() }
        }
        .padding()
    }
}

// ────────────────────────────────────────────────────────────────────────────
// MARK: - 2. ADVANCED: a custom bottom sheet overlay you can fully style
//
// Use this only if you need behavior `.sheet` can't do (e.g. a sheet that stays
// within the current view, custom background dimming, no separate presentation).
// ────────────────────────────────────────────────────────────────────────────

struct CustomBottomSheet<Content: View>: View {
    @Binding var isPresented: Bool
    @ViewBuilder var content: Content

    // Tracks the in-progress drag so the sheet follows the finger.
    @State private var dragOffset: CGFloat = 0

    var body: some View {
        ZStack(alignment: .bottom) {
            if isPresented {
                // Dimmed backdrop — tap to dismiss.
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture { close() }
                    .transition(.opacity)

                // The sheet itself.
                VStack {
                    Capsule()                          // grabber
                        .fill(Color(.systemGray3))
                        .frame(width: 40, height: 5)
                        .padding(.top, 8)
                    content.padding()
                }
                .frame(maxWidth: .infinity)
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 24))
                .offset(y: dragOffset)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            dragOffset = max(0, value.translation.height)   // only drag down
                        }
                        .onEnded { value in
                            if value.translation.height > 120 { close() }   // dragged far → dismiss
                            else { withAnimation(.spring) { dragOffset = 0 } } // snap back
                        }
                )
                .transition(.move(edge: .bottom))
            }
        }
        .animation(.spring(duration: 0.35), value: isPresented)
    }

    private func close() {
        withAnimation(.spring) { isPresented = false }
        dragOffset = 0
    }
}

// MARK: - Previews

#Preview("Simple") { BottomSheetSimple() }

#Preview("Custom") {
    struct Demo: View {
        @State private var show = false
        var body: some View {
            ZStack {
                Button("Show custom sheet") { show = true }
                CustomBottomSheet(isPresented: $show) {
                    VStack(spacing: 12) {
                        Text("Custom Sheet").font(.headline)
                        Text("Drag down or tap outside to dismiss.")
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
    }
    return Demo()
}
