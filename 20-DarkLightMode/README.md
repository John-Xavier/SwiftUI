# Dark Mode / Light Mode

How to make your UI look right in both appearances — and let the user override it.

## Files

- [`ColorSchemeExamples.swift`](./ColorSchemeExamples.swift) — semantic colors, reading `colorScheme`, per-view overrides, previewing both.
- [`ThemeSwitcher.swift`](./ThemeSwitcher.swift) — a persisted System / Light / Dark picker driving the whole app.

## The golden rule: use semantic (adaptive) colors

Adaptive colors change automatically between light and dark. **Never hard-code `.white`/`.black` for backgrounds/text.**

| Instead of | Use |
|------------|-----|
| `.white` background | `Color(.systemBackground)` |
| `.black` text | `.primary` (and `.secondary` for subtitles) |
| A custom gray | `Color(.secondarySystemBackground)`, `.tertiary`, etc. |
| A hard-coded brand color | A **Color Set** in your asset catalog with Any/Dark variants |

```swift
Text("Title").foregroundStyle(.primary)          // adapts
    .background(Color(.systemBackground))         // adapts
```

## Asset catalog colors (for brand colors)

1. Assets → **+ → Color Set**, name it e.g. `BrandPrimary`.
2. In the Attributes inspector set **Appearances = Any, Dark**.
3. Pick a color for each.
4. Use it: `Color("BrandPrimary")` — it now switches automatically.

## Reacting to the current scheme in code

```swift
@Environment(\.colorScheme) private var colorScheme   // .light or .dark

var shadowOpacity: Double { colorScheme == .dark ? 0.6 : 0.15 }
```

## Forcing a scheme

- **One view/subtree:** `.preferredColorScheme(.dark)`
- **Whole app (user setting):** drive `.preferredColorScheme` from a persisted `@AppStorage` value — see [`ThemeSwitcher.swift`](./ThemeSwitcher.swift).

## Always preview both

```swift
#Preview("Light") { MyView().preferredColorScheme(.light) }
#Preview("Dark")  { MyView().preferredColorScheme(.dark) }
```

## Quick audit checklist

- [ ] No hard-coded black/white for text or backgrounds.
- [ ] Brand colors are Color Sets with dark variants.
- [ ] Images/icons legible on both (use SF Symbols or provide dark assets).
- [ ] Shadows/borders still visible in dark mode.
- [ ] Previewed in both appearances.
