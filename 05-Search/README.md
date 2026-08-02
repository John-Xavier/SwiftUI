# Search

SwiftUI's `.searchable` modifier adds a native search bar to a `List` or `ScrollView` inside a `NavigationStack`.

## Files

- [`BasicSearch.swift`](./BasicSearch.swift) — `.searchable` + live filtering of a local array.
- [`SearchWithScopes.swift`](./SearchWithScopes.swift) — search scopes (segmented filter) + suggestions.
- [`DebouncedSearch.swift`](./DebouncedSearch.swift) — debounce keystrokes before hitting the network.

## Essentials

```swift
NavigationStack {
    List(filtered) { ... }
        .searchable(text: $query, prompt: "Search users")
}
```

- **`.searchable(text:)`** binds the search field to a `@State String`.
- **Filter in a computed property** — recomputed on every keystroke, cheap for local arrays.
- **`.searchScopes`** adds a segmented control (e.g. All / Name / Email).
- **`.searchSuggestions`** shows tappable suggestions as the user types.

## Local vs. network search

| Data size | Approach |
|-----------|----------|
| In-memory array | Filter in a computed property. Instant. See `BasicSearch`. |
| Server-backed | **Debounce** keystrokes (e.g. 300 ms) before calling the API to avoid a request per character. See `DebouncedSearch`. |

## Case/diacritic-insensitive matching

```swift
name.localizedCaseInsensitiveContains(query)   // "jose" matches "José"? use localizedStandard for that
name.range(of: query, options: [.caseInsensitive, .diacriticInsensitive]) != nil
```
