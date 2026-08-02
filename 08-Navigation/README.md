# Navigation

`NavigationStack` (iOS 16+) replaced the deprecated `NavigationView`. It supports both simple link-based pushes and full **programmatic** navigation via a bound path.

## Files

- [`BasicNavigation.swift`](./BasicNavigation.swift) — `NavigationLink`, `navigationDestination`.
- [`ProgrammaticNavigation.swift`](./ProgrammaticNavigation.swift) — a bound `path` you can push/pop in code, deep-linking, pop-to-root.
- [`TabViewExample.swift`](./TabViewExample.swift) — `TabView` with per-tab navigation stacks.

## Two styles of pushing

```swift
// 1. Link the user taps:
NavigationLink("Details", value: user)

// 2. Register how to build a screen for a value type:
.navigationDestination(for: User.self) { user in
    UserDetail(user: user)
}
```

## Programmatic navigation

Bind a `path` array. Append to push, remove to pop, clear to pop-to-root:

```swift
@State private var path: [Route] = []

NavigationStack(path: $path) { ... }

path.append(.detail(user))   // push
path.removeLast()            // pop
path.removeAll()             // pop to root
```

## Sheets vs. push

| Presentation | Modifier | Use for |
|--------------|----------|---------|
| Push (drill-in) | `NavigationLink` / `path` | Hierarchical content |
| Sheet (modal card) | `.sheet(isPresented:)` | Self-contained tasks (compose, settings) |
| Full-screen modal | `.fullScreenCover` | Onboarding, media |

> Sheet/cover snippets live in [../12-AlertsAndSheets](../12-AlertsAndSheets).
