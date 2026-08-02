# Networking

A modern SwiftUI network layer built on **`async/await`** and `URLSession`. No third-party libraries.

## Files

- [`APIError.swift`](./APIError.swift) — a typed error enum with user-friendly messages.
- [`Endpoint.swift`](./Endpoint.swift) — a lightweight, testable way to describe requests.
- [`APIClient.swift`](./APIClient.swift) — a generic client: `func request<T: Decodable>(...) async throws -> T`.
- [`UserService.swift`](./UserService.swift) — a feature service built on top of the client.
- [`UserListViewModel.swift`](./UserListViewModel.swift) — a `@MainActor` view model that drives the UI.
- [`UserListView.swift`](./UserListView.swift) — the SwiftUI view wiring it all together (loading / error / data states).

## The layers

```
View  ──uses──▶  ViewModel  ──uses──▶  Service  ──uses──▶  APIClient  ──uses──▶  URLSession
```

Each layer has one job, which makes each layer independently testable:

| Layer | Responsibility |
|-------|----------------|
| `APIClient` | Build the `URLRequest`, run it, decode JSON, map errors. Knows nothing about *your* models. |
| `Service` | Feature-specific calls: `fetchUsers()`, `fetchUser(id:)`. |
| `ViewModel` | Hold UI state (`loading`/`loaded`/`error`), call the service, expose it to the view. |
| `View` | Render state. No networking logic. |

## Why async/await over completion handlers

- Linear, readable code (no callback pyramids).
- `try`/`catch` error handling instead of `Result` juggling.
- Automatic cancellation via structured concurrency (`Task`).

## Cheat sheet

```swift
// Fire a request from a view model (already on the MainActor):
func load() async {
    state = .loading
    do {
        users = try await service.fetchUsers()
        state = .loaded
    } catch {
        state = .error(error.localizedDescription)
    }
}
```

## Testing tip

Because `APIClient` depends only on a `URLSession` and services depend on a
**protocol**, you can inject a mock in tests — see
[../03-DependencyInjection](../03-DependencyInjection).
