//
//  SegmentedControls.swift
//  Native segmented picker (simple) + a custom animated segmented control.
//

import SwiftUI

// MARK: - 1. Native segmented control (use this 90% of the time)
//
// It's just a Picker with `.segmentedStyle`. Bind it to any Hashable selection.

struct NativeSegmented: View {
    enum Tab: String, CaseIterable, Identifiable { case all, active, done; var id: Self { self } }
    @State private var selection: Tab = .all

    var body: some View {
        Picker("Filter", selection: $selection) {
            ForEach(Tab.allCases) { tab in
                Text(tab.rawValue.capitalized).tag(tab)
            }
        }
        .pickerStyle(.segmented)
        .padding()
    }
}

// MARK: - 2. Custom segmented control (when you want your own look/animation)
//
// A sliding highlight built with a ZStack + matchedGeometryEffect.

struct CustomSegmentedControl: View {
    let options: [String]
    @Binding var selection: Int

    // Ties the moving highlight to the selected segment.
    @Namespace private var namespace

    var body: some View {
        HStack(spacing: 0) {
            ForEach(options.indices, id: \.self) { index in
                let isSelected = selection == index

                Text(options[index])
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(isSelected ? .white : .primary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background {
                        if isSelected {
                            // The highlight "slides" because it shares an id across segments.
                            Capsule()
                                .fill(.blue)
                                .matchedGeometryEffect(id: "highlight", in: namespace)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation(.spring(duration: 0.3)) { selection = index }
                    }
            }
        }
        .padding(4)
        .background(Color(.secondarySystemBackground), in: Capsule())
    }
}

// MARK: - Preview

#Preview {
    struct Demo: View {
        @State private var custom = 0
        var body: some View {
            VStack(spacing: 32) {
                NativeSegmented()
                CustomSegmentedControl(options: ["Day", "Week", "Month"], selection: $custom)
                    .padding(.horizontal)
            }
        }
    }
    return Demo()
}
