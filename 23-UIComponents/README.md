# UI Components (Design Elements)

The most-used, reusable design elements — buttons, pills, tags, badges, cards, avatars, chips, and toasts. Copy a file, drop the element in, restyle to taste.

## Files

| File | Elements |
|------|----------|
| [`Buttons.swift`](./Buttons.swift) | Primary / secondary / tertiary / destructive buttons, full-width, icon button, **loading button**, reusable `ButtonStyle`s |
| [`PillsTagsBadges.swift`](./PillsTagsBadges.swift) | Pill, tag, **removable chip**, status badge (dot + label), count/notification badge |
| [`Cards.swift`](./Cards.swift) | Basic card, image card, info/list card |
| [`Avatars.swift`](./Avatars.swift) | Circle avatar, **initials** avatar, avatar with status dot, overlapping avatar stack |
| [`Chips.swift`](./Chips.swift) | Selectable filter chips (single & multi-select), wrapping chip layout |
| [`Toast.swift`](./Toast.swift) | Toast / snackbar overlay with auto-dismiss |
| [`SegmentedControls.swift`](./SegmentedControls.swift) | Native segmented `Picker` + a custom animated segmented control |
| [`TogglesAndSwitches.swift`](./TogglesAndSwitches.swift) | Native switch, tinted, **checkbox** `ToggleStyle`, fully custom switch |
| [`SearchBar.swift`](./SearchBar.swift) | Custom search bar (clear + cancel) — for where `.searchable` can't go |
| [`RatingStars.swift`](./RatingStars.swift) | Read-only star rating (halves) + interactive tap-to-rate |
| [`SkeletonLoaders.swift`](./SkeletonLoaders.swift) | Shimmering skeleton placeholders while data loads |
| [`BottomSheet.swift`](./BottomSheet.swift) | Simple `.presentationDetents` sheet + a custom draggable overlay |
| [`SampleScreen.swift`](./SampleScreen.swift) | **A full profile screen assembling all of the above into one UI** |

## Design tokens first (do this once)

Consistency comes from **reusing values**, not hard-coding them everywhere. Define spacing/radius/colors once and reference them. A minimal example ships in [`Buttons.swift`](./Buttons.swift):

```swift
enum Theme {
    static let cornerRadius: CGFloat = 12
    static let spacing: CGFloat = 12
    static let accent = Color.blue
}
```

Better still, use **semantic colors** (`.primary`, `Color(.systemBackground)`) and
asset **Color Sets** so everything adapts to dark mode automatically — see
[../20-DarkLightMode](../20-DarkLightMode).

## The two ways to make a reusable button

1. **`ButtonStyle`** (preferred) — style is separate from behavior, press states for free:
   ```swift
   Button("Save") { }.buttonStyle(PrimaryButtonStyle())
   ```
2. **A wrapper `View`** — when the button also owns layout/state (e.g. a loading spinner):
   ```swift
   LoadingButton("Save", isLoading: $saving) { await save() }
   ```

## Conventions used here

- Every element is a small, self-contained `View` or `ButtonStyle` with a `#Preview`.
- Elements use **semantic colors** where possible so they work in light & dark mode.
- Reusable modifiers (`.pill()`, `.cardStyle()`) build on [../14-ExtensionsAndModifiers](../14-ExtensionsAndModifiers).
