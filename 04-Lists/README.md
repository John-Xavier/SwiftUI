# Lists

`List` is SwiftUI's scrollable, row-based container. It handles cell reuse, separators, and swipe actions for you.

## Files

- [`BasicList.swift`](./BasicList.swift) — plain list, `ForEach`, custom rows, sections.
- [`ListWithNavigation.swift`](./ListWithNavigation.swift) — tappable rows pushing detail screens.
- [`EditableList.swift`](./EditableList.swift) — swipe-to-delete, move/reorder, `EditButton`.

## Essentials

- **`List(items) { item in ... }`** needs items to be `Identifiable`, or pass `id: \.self` / `id: \.someKey`.
- **`ForEach`** inside a `List` when you need sections or mixed content.
- **`Section`** groups rows with an optional header/footer.
- **`.listStyle(...)`** — `.plain`, `.insetGrouped`, `.grouped`, `.sidebar`.
- **`.refreshable { }`** adds pull-to-refresh.
- **`.swipeActions { }`** adds custom leading/trailing swipe buttons.

## Identifiable vs. id:

```swift
List(users) { ... }              // users: [User] where User: Identifiable  ✅ preferred
List(names, id: \.self) { ... }  // names: [String]  — use \.self for value types
```

> ⚠️ Avoid `id: \.self` on large or mutable model arrays — if two elements are equal, SwiftUI can't tell rows apart. Prefer a real stable `id`.

## Performance

For very large or infinite lists, `List` already lazily loads rows. For custom
scroll views use `LazyVStack` — see [../11-Layout](../11-Layout).
