# Accessibility

Making your app usable with VoiceOver, Dynamic Type, and other assistive tech. SwiftUI is accessible by default — these tools fill the gaps and polish the experience.

## Files

- [`AccessibilityExamples.swift`](./AccessibilityExamples.swift) — labels, values, traits, hints, grouping, hiding decorative views.
- [`DynamicTypeExample.swift`](./DynamicTypeExample.swift) — supporting large text sizes without breaking layouts.

## The checklist (do these on every screen)

1. **Label every meaningful control.** Icon-only buttons especially:
   ```swift
   Button { } label: { Image(systemName: "trash") }
       .accessibilityLabel("Delete")
   ```
2. **Combine related elements** so VoiceOver reads a card as one unit:
   ```swift
   .accessibilityElement(children: .combine)
   ```
3. **Hide decorative images** so they aren't announced:
   ```swift
   Image("sparkle").accessibilityHidden(true)
   ```
4. **Use semantic fonts** (`.headline`, `.body`) — they scale with Dynamic Type automatically. Avoid hard-coded `.font(.system(size: 14))`.
5. **Don't rely on color alone** — pair color with text/icons (color-blind users).
6. **Respect Reduce Motion**:
   ```swift
   @Environment(\.accessibilityReduceMotion) private var reduceMotion
   ```

## Key modifiers

| Modifier | Purpose |
|----------|---------|
| `.accessibilityLabel("…")` | What the element *is* ("Delete") |
| `.accessibilityValue("…")` | Its current value ("70 percent") |
| `.accessibilityHint("…")` | What happens on activation ("Deletes the item") |
| `.accessibilityAddTraits(.isButton)` | Declare behavior (button, header, selected…) |
| `.accessibilityElement(children:)` | Combine / ignore child elements |
| `.accessibilityHidden(true)` | Remove from the accessibility tree |
| `.accessibilitySortPriority(_:)` | Control VoiceOver reading order |

## Testing

- **Xcode → Accessibility Inspector** (audit + live inspection).
- On device: **Settings → Accessibility → VoiceOver** — swipe through your screens.
- **Dynamic Type**: enable **Larger Text** and drag to the max — nothing should clip or overlap.
