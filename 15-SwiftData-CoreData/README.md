# SwiftData & Core Data

Local databases for when `UserDefaults`/JSON files aren't enough (querying, relationships, large datasets).

- **SwiftData** (iOS 17+) — modern, Swift-native, minimal boilerplate. **Prefer this for new apps on iOS 17+.**
- **Core Data** — mature, powerful, supports iOS 13+. Reach for it when you need to support older OSes or use advanced features SwiftData doesn't expose yet.

## Files

- [`SwiftDataExample.swift`](./SwiftDataExample.swift) — `@Model`, `@Query`, `modelContext` insert/delete — a full CRUD list.
- [`CoreData-StepByStep.md`](./CoreData-StepByStep.md) — step-by-step guide to wiring up Core Data (no full code dump; the boilerplate is Xcode-generated).

## Which should I use?

| Situation | Use |
|-----------|-----|
| New app, iOS 17+ | **SwiftData** |
| Must support iOS 13–16 | **Core Data** |
| Need CloudKit sync | Either (both support it; Core Data is more battle-tested) |
| Simple settings/flags | Neither — use [`@AppStorage`](../10-Persistence) |

## SwiftData in 30 seconds

```swift
@Model final class Task { var title: String; init(title: String) { self.title = title } }

// App entry:
.modelContainer(for: Task.self)

// In a view:
@Environment(\.modelContext) private var context
@Query private var tasks: [Task]

context.insert(Task(title: "Buy milk"))   // create
context.delete(task)                       // delete
// updates: just mutate a @Model property — saved automatically
```

## Mental model (both frameworks)

```
Model (schema)  →  Container (the store/DB file)  →  Context (a scratchpad you read/write)  →  View
```

- **Container** = the on-disk database.
- **Context** = the in-memory workspace; changes are saved back to the container.
- **`@Query`** (SwiftData) / `@FetchRequest` (Core Data) = a live query that auto-updates the UI when data changes.
