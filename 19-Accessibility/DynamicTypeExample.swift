//
//  DynamicTypeExample.swift
//  Supporting large text sizes without breaking layouts.
//

import SwiftUI

struct DynamicTypeExample: View {
    // Read the user's text-size setting to adapt layout at very large sizes.
    @Environment(\.dynamicTypeSize) private var typeSize

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            // 1. Use SEMANTIC fonts — they scale automatically with Dynamic Type.
            //    (Avoid .font(.system(size: 14)) — that's fixed and ignores the setting.)
            Text("Headline").font(.headline)
            Text("Body text scales with the user's preferred size.").font(.body)

            // 2. Switch an HStack to a VStack at accessibility sizes so labels
            //    and controls don't get squeezed / truncated.
            layoutAdaptiveRow

            // 3. Optionally CAP the maximum size for a specific element (e.g. a
            //    fixed-height badge) so it can't blow up the layout.
            Text("Badge")
                .padding(6)
                .background(.blue.opacity(0.2), in: Capsule())
                .dynamicTypeSize(...DynamicTypeSize.accessibility1)   // clamp upper bound
        }
        .padding()
    }

    // When the text is huge, stack vertically instead of side-by-side.
    @ViewBuilder
    private var layoutAdaptiveRow: some View {
        let label = Text("Notifications")
        let control = Toggle("", isOn: .constant(true)).labelsHidden()

        if typeSize.isAccessibilitySize {
            VStack(alignment: .leading) { label; control }
        } else {
            HStack { label; Spacer(); control }
        }
    }
}

// Preview at multiple sizes to catch clipping early.
#Preview("Default") {
    DynamicTypeExample()
}
#Preview("XXXL") {
    DynamicTypeExample()
        .environment(\.dynamicTypeSize, .accessibility3)
}
