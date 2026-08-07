//
//  Chips.swift
//  Selectable filter chips (single & multi-select) + a wrapping layout.
//

import SwiftUI

// MARK: - 1. A single selectable chip

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                if isSelected { Image(systemName: "checkmark").font(.caption2) }
                Text(title).font(.subheadline)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            // Filled when selected, outlined when not.
            .background {
                if isSelected {
                    Capsule().fill(.blue)
                } else {
                    Capsule().stroke(.gray.opacity(0.4), lineWidth: 1)
                }
            }
            .foregroundStyle(isSelected ? .white : .primary)
        }
        .animation(.easeOut(duration: 0.15), value: isSelected)
    }
}

// MARK: - 2. Multi-select chip group (Set-backed)

struct MultiSelectChips: View {
    let options: [String]
    @Binding var selected: Set<String>

    var body: some View {
        // For a few options a simple HStack in a ScrollView is fine.
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(options, id: \.self) { option in
                    FilterChip(title: option, isSelected: selected.contains(option)) {
                        if selected.contains(option) { selected.remove(option) }
                        else { selected.insert(option) }
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

// ────────────────────────────────────────────────────────────────────────────
// MARK: - 3. ADVANCED: a wrapping "flow" layout (chips wrap to the next line)
//
// iOS 16's `Layout` protocol lets us build a left-to-right layout that wraps —
// something SwiftUI has no built-in container for. Drop any views inside.
// ────────────────────────────────────────────────────────────────────────────

struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let maxWidth = proposal.width ?? .infinity
        var (x, y, rowHeight): (CGFloat, CGFloat, CGFloat) = (0, 0, 0)

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > maxWidth {           // wrap to next row
                x = 0
                y += rowHeight + spacing
                rowHeight = 0
            }
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
        return CGSize(width: maxWidth, height: y + rowHeight)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var (x, y, rowHeight): (CGFloat, CGFloat, CGFloat) = (bounds.minX, bounds.minY, 0)

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > bounds.maxX {        // wrap
                x = bounds.minX
                y += rowHeight + spacing
                rowHeight = 0
            }
            subview.place(at: CGPoint(x: x, y: y), proposal: ProposedViewSize(size))
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
    }
}

// MARK: - Preview

#Preview("Selectable") {
    struct Demo: View {
        @State private var selected: Set<String> = ["Swift"]
        let tags = ["Swift", "SwiftUI", "Combine", "Async", "Testing", "Charts", "Core Data"]
        var body: some View {
            VStack(alignment: .leading, spacing: 20) {
                MultiSelectChips(options: tags, selected: $selected)

                // Same chips, wrapping instead of scrolling:
                FlowLayout {
                    ForEach(tags, id: \.self) { tag in
                        FilterChip(title: tag, isSelected: selected.contains(tag)) {
                            if selected.contains(tag) { selected.remove(tag) } else { selected.insert(tag) }
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    return Demo()
}
