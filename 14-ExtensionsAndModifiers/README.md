# Extensions & Modifiers

Reusable building blocks that keep your views DRY: custom `ViewModifier`s, `View` extensions, and handy `Color`/`String` helpers.

## Files

- [`CustomViewModifier.swift`](./CustomViewModifier.swift) — a `CardStyle` modifier + `.cardStyle()` sugar.
- [`ViewExtensions.swift`](./ViewExtensions.swift) — `.if()` conditional modifier, `.hidden(_:)`, corner radius on specific corners.
- [`ColorAndStringExtensions.swift`](./ColorAndStringExtensions.swift) — `Color(hex:)`, email validation, trimming.

## Why custom modifiers

Instead of repeating `.padding().background(...).cornerRadius(...)` on every card,
define it once:

```swift
struct CardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content.padding().background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
    }
}
extension View { func cardStyle() -> some View { modifier(CardStyle()) } }

// Usage:
Text("Hi").cardStyle()
```

## The `.if` conditional modifier

Apply a modifier only when a condition is true:

```swift
Text("Hi").if(isHighlighted) { $0.foregroundStyle(.red) }
```

> Use `.if` sparingly — changing a view's modifier *identity* between branches
> can reset state/animations. For simple styling it's fine; for structural
> changes prefer a plain `if` in the view body.

## Color from hex

`Color(hex: "#FF8800")` — because designers hand you hex, not RGB doubles.
