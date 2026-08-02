# Dependency Injection

"Dependency injection" just means: **give an object its dependencies from the outside** instead of it creating them itself. That makes code testable (swap in a mock) and flexible (swap the real thing).

SwiftUI gives you several built-in mechanisms.

## The three common approaches

| Approach | Use when | File |
|----------|----------|------|
| **Initializer injection** | The default. Pass dependencies into `init`. | [`InitializerInjection.swift`](./InitializerInjection.swift) |
| **`@EnvironmentObject`** | Share one object with a whole view subtree (e.g. session, cart). | [`EnvironmentObjectDI.swift`](./EnvironmentObjectDI.swift) |
| **Custom `EnvironmentKey`** | Inject a *value/service* through `@Environment` without an `ObservableObject`. | [`CustomEnvironmentKey.swift`](./CustomEnvironmentKey.swift) |

## Rules of thumb

- **Depend on protocols, not concrete types.** `UserServiceProtocol`, not `UserService`. Then a mock is a drop-in.
- **`@EnvironmentObject` crashes if not provided** — always inject it with `.environmentObject(...)` at the root, or previews will crash.
- **Initializer injection is the most explicit and testable** — prefer it unless you genuinely need tree-wide sharing.

## Quick example (initializer injection)

```swift
// Production
let client  = APIClient(baseURL: URL(string: "https://api.example.com")!)
let service = UserService(client: client)
UserListView(service: service)

// Tests / previews
UserListView(service: MockUserService())
```
