# Animations

SwiftUI animates changes to view state. You describe the *what*; SwiftUI interpolates the *how*.

## Files

- [`ImplicitAndExplicit.swift`](./ImplicitAndExplicit.swift) — `.animation(_:value:)` vs `withAnimation { }`.
- [`Transitions.swift`](./Transitions.swift) — insertion/removal transitions for appearing views.
- [`MatchedGeometry.swift`](./MatchedGeometry.swift) — hero animations with `matchedGeometryEffect`.

## Implicit vs. explicit

```swift
// Implicit — animate whenever `isBig` changes:
.scaleEffect(isBig ? 2 : 1)
.animation(.spring, value: isBig)

// Explicit — animate the state change you wrap:
withAnimation(.easeInOut) { isBig.toggle() }
```

Prefer **`.animation(_:value:)`** (scoped to a specific value) over the deprecated
value-less `.animation(_:)`, which animated *everything*.

## Common curves

| Curve | Feel |
|-------|------|
| `.linear` | Constant speed |
| `.easeInOut` | Smooth start & stop |
| `.spring` | Natural, bouncy (default in many places) |
| `.bouncy`, `.snappy`, `.smooth` (iOS 17) | Named spring presets |

## Transitions

`transition(...)` animates a view being **added or removed** (inside a
`withAnimation` block), e.g. `.opacity`, `.slide`, `.scale`, `.move(edge:)`,
or `.asymmetric(insertion:removal:)`.

## Hero animations

`matchedGeometryEffect(id:in:)` + a shared `@Namespace` morphs a view from one
position/size to another across a state change — think tapping a thumbnail that
expands to full screen.
