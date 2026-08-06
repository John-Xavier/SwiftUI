# Persistence

How to save data locally. **Read the files top-to-bottom — simplest first, advanced last.**

## Files (simple → advanced)

| Order | File | Level | What it does |
|-------|------|-------|--------------|
| 1 | [`SimpleUserDefaults.swift`](./SimpleUserDefaults.swift) | 🟢 Simple | Save/read small values (String, Bool, Int) — **start here** |
| 2 | [`AppStorageExample.swift`](./AppStorageExample.swift) | 🟢 Simple | `@AppStorage` — the same thing, wired to the UI automatically |
| 3 | [`Keychain.swift`](./Keychain.swift) | 🟢→🔴 | Securely store secrets (tokens/passwords); simple helper first, Codable version at the bottom |
| 4 | [`JSONFileStore.swift`](./JSONFileStore.swift) | 🟡 Medium | Save `Codable` lists/documents as JSON files on disk |
| 5 | [`UserDefaultsWrapper.swift`](./UserDefaultsWrapper.swift) | 🔴 Advanced | Generic + `@propertyWrapper` helpers for storing your own types |

For databases (SwiftData / Core Data) see [../15-SwiftData-CoreData](../15-SwiftData-CoreData).

## Choose the right tool

| Data | Use |
|------|-----|
| Small settings (bool, string, int) | `@AppStorage` / `UserDefaults` |
| **Secrets** (auth token, password, API key) | **Keychain** (encrypted) — never UserDefaults |
| Small `Codable` object | `UserDefaults` (encoded to `Data`) |
| Lists / documents (Codable) | JSON file in the Documents directory |
| Large / queryable / relational | **SwiftData** (iOS 17) or **Core Data** |

> ⚠️ `@AppStorage` and `UserDefaults` are **not** for large data or secrets. They load fully into memory and are stored as plain text.

## 10-second cheat sheet

```swift
// Simple value that persists AND updates the UI:
@AppStorage("isDarkMode") private var isDarkMode = false

// A secret (encrypted):
KeychainHelper.save(token, for: "authToken")
let token = KeychainHelper.read(for: "authToken")

// A Codable list to disk:
try JSONFileStore.save(users, to: "users.json")
let users: [User] = try JSONFileStore.load(from: "users.json")
```
