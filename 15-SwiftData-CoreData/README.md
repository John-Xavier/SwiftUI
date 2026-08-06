# SwiftData & Core Data

Local databases for when `UserDefaults`/JSON files aren't enough (querying, relationships, large datasets).

- **SwiftData** (iOS 17+) — modern, Swift-native, minimal boilerplate. **Prefer this for new apps on iOS 17+.**
- **Core Data** — mature, supports iOS 13+. Use it when you must support older OSes.

## Files (simple → advanced)

| Order | File | Level | What it does |
|-------|------|-------|--------------|
| 1 | [`SwiftData-Simple.swift`](./SwiftData-Simple.swift) | 🟢 Simple | Smallest possible SwiftData app — **start here** |
| 2 | [`SwiftData-FullCRUD.swift`](./SwiftData-FullCRUD.swift) | 🟡 Medium | Full create/read/update/delete list with sorting & toggles |
| 3 | [`CoreData-Simple.swift`](./CoreData-Simple.swift) | 🟡 Medium | The smallest working Core Data setup, in plain code |
| 4 | [`CoreData-StepByStep.md`](./CoreData-StepByStep.md) | 🔴 Reference | Full walkthrough incl. the Xcode model-file step & gotchas |

## Which should I use?

| Situation | Use |
|-----------|-----|
| New app, iOS 17+ | **SwiftData** |
| Must support iOS 13–16 | **Core Data** |
| Simple settings/flags | Neither — use [`@AppStorage`](../10-Persistence) |
| Secrets (tokens) | Neither — use [Keychain](../10-Persistence/Keychain.swift) |

## SwiftData in 3 steps

```swift
// 1. Mark the class:
@Model final class Note { var text: String; init(text: String) { self.text = text } }

// 2. Turn on the database once, at the app root:
.modelContainer(for: Note.self)

// 3. Read + write in a view:
@Environment(\.modelContext) private var context
@Query private var notes: [Note]

context.insert(Note(text: "Hi"))   // create (saved automatically)
context.delete(note)                // delete
note.text = "Edited"               // update — just mutate, it saves
```

## Mental model (both frameworks)

```
Model (your class/entity)  →  Container (the database file)  →  Context (add/edit/delete here)  →  save
```

- **SwiftData** saves automatically. **Core Data** needs an explicit `context.save()`.
- **`@Query`** (SwiftData) / **`@FetchRequest`** (Core Data) = a live query that auto-updates the UI.
