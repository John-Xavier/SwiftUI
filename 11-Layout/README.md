# Layout

How SwiftUI arranges views: stacks, grids, spacers, and reading available space.

## Files

- [`StacksAndSpacing.swift`](./StacksAndSpacing.swift) — `VStack`/`HStack`/`ZStack`, `Spacer`, alignment, padding.
- [`GridLayouts.swift`](./GridLayouts.swift) — `LazyVGrid`/`LazyHGrid` (adaptive & fixed) and iOS 16 `Grid`.
- [`GeometryAndAdaptive.swift`](./GeometryAndAdaptive.swift) — `GeometryReader`, `ViewThatFits`, size classes.

## The core layout system

- **`VStack` / `HStack` / `ZStack`** — vertical / horizontal / depth stacking.
- **`Spacer()`** — a flexible gap that pushes siblings apart.
- **`.padding()`, `.frame()`, `.alignmentGuide()`** — fine-tune spacing and size.
- **`LazyVGrid` / `LazyVStack`** — lazy = only builds visible cells (use for long scrolls).
- **`Grid` (iOS 16)** — true 2D grid with row/column alignment, for tabular layouts.

## Grid columns cheat sheet

```swift
// Adaptive: as many columns as fit, each ≥ 100pt wide.
let columns = [GridItem(.adaptive(minimum: 100))]

// Fixed count: exactly 3 equal columns.
let columns = Array(repeating: GridItem(.flexible()), count: 3)

// Mixed: a fixed 80pt column then a flexible one.
let columns = [GridItem(.fixed(80)), GridItem(.flexible())]
```

## Adaptive UI

- Use **`ViewThatFits`** to pick the first layout that fits — great for buttons that go horizontal on wide screens, vertical on narrow.
- Read **size classes** with `@Environment(\.horizontalSizeClass)` to branch iPhone vs. iPad.
- Reach for **`GeometryReader` sparingly** — it's greedy with space and can complicate layout. Prefer `ViewThatFits`, `frame`, and containerRelativeFrame first.
