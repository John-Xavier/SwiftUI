# State Management

Choosing the right property wrapper is the single most important SwiftUI skill. Here's the decision table.

## The property wrappers

| Wrapper | Owns the data? | Data type | Use for |
|---------|----------------|-----------|---------|
| `@State` | ✅ this view | value (struct/primitive) | Simple view-local state (toggles, text, selection) |
| `@Binding` | ❌ (borrows) | value | A child mutating a parent's `@State` |
| `@StateObject` | ✅ this view | `ObservableObject` (class) | View model this view **creates** and owns |
| `@ObservedObject` | ❌ (passed in) | `ObservableObject` | View model **passed** from a parent |
| `@EnvironmentObject` | ❌ (from env) | `ObservableObject` | Shared object injected up the tree |
| `@Observable` (iOS 17) | — | class macro | Modern replacement for `ObservableObject` |

## Files

- [`StateAndBinding.swift`](./StateAndBinding.swift) — `@State` in a parent, `@Binding` in a child.
- [`ObservableObjectPattern.swift`](./ObservableObjectPattern.swift) — `@StateObject` vs `@ObservedObject`.
- [`ObservableMacro.swift`](./ObservableMacro.swift) — iOS 17 `@Observable` (the modern way).

## The golden rules

1. **Own it once with `@StateObject`.** The view that *creates* a view model uses `@StateObject`. Children that *receive* it use `@ObservedObject`.
2. **`@State` is for value types.** Use it for `Bool`, `String`, `Int`, small structs.
3. **`@Binding` = a two-way reference to someone else's `@State`.** Pass it with `$`.
4. **Never create an `ObservableObject` in `@ObservedObject`** — it gets recreated on every re-render and loses state. Use `@StateObject`.

## iOS 17: `@Observable`

The `@Observable` macro replaces `ObservableObject` + `@Published`. Views observe
it with plain `@State` (for owned) or by passing it directly. It only re-renders
views that read the *specific* properties that changed — more efficient.
