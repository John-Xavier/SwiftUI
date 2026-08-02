# Persistence

How to save data locally, from simplest to most capable.

## Files

- [`AppStorageExample.swift`](./AppStorageExample.swift) — `@AppStorage` for settings/flags (wraps `UserDefaults`).
- [`UserDefaultsWrapper.swift`](./UserDefaultsWrapper.swift) — a typed `UserDefaults` helper for `Codable` values.
- [`JSONFileStore.swift`](./JSONFileStore.swift) — save/load `Codable` arrays as JSON files on disk.

## Choose the right tool

| Data | Use |
|------|-----|
| Small settings (bool, string, int) | `@AppStorage` / `UserDefaults` |
| Small `Codable` object | `UserDefaults` (encoded to `Data`) |
| Lists/documents (Codable) | JSON file in the Documents directory |
| Large/queryable/relational | **SwiftData** (iOS 17) or Core Data |

> `@AppStorage` and `UserDefaults` are **not** for large data — they load fully into memory. Use a file or a database for anything sizable.

## Cheat sheet

```swift
// Setting that persists automatically and drives the UI:
@AppStorage("isDarkMode") private var isDarkMode = false

// Codable to disk:
try JSONFileStore.save(users, to: "users.json")
let users: [User] = try JSONFileStore.load("users.json")
```
