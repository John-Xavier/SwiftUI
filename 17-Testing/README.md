# Unit Testing (the Network Layer)

How to test networking **without hitting the real network** — fast, deterministic, offline. Two techniques, from simplest to most thorough.

## Files

- [`MockServiceTests.swift`](./MockServiceTests.swift) — test view models by injecting a mock **service** (simplest, recommended default).
- [`URLProtocolStubTests.swift`](./URLProtocolStubTests.swift) — test the real `APIClient` by stubbing **`URLSession`** with a custom `URLProtocol` (tests decoding + status handling for real).
- [`SwiftTestingExample.swift`](./SwiftTestingExample.swift) — the same idea using the new **Swift Testing** framework (`@Test`/`#expect`, Xcode 16+).

## The strategy

```
┌─ View model tests ──────────────┐   inject MockUserService → assert state transitions
│  fast, no URLSession involved   │   (covers YOUR logic)
└─────────────────────────────────┘
┌─ APIClient tests ───────────────┐   stub URLSession via URLProtocol → feed canned JSON
│  exercises real decode + errors │   (covers the CLIENT itself)
└─────────────────────────────────┘
```

Both rely on the **dependency injection** from [../03-DependencyInjection](../03-DependencyInjection):
services depend on `APIClientProtocol`, and `APIClient` takes an injectable `URLSession`.

## Why URLProtocol?

`URLSession` has no "server" to point at in tests. A custom `URLProtocol` intercepts
every request the session makes and lets you return whatever `Data`, status code, or
error you want — no server, no network, fully deterministic.

## Testing async code

- **XCTest**: mark the test `async` and `await` the call. Use `XCTAssertThrowsError` with `try await`.
- **Swift Testing**: `@Test func …() async throws`, then `#expect(...)` / `#expect(throws:)`.

```swift
func testFetchUsersReturnsUsers() async throws {
    let sut = UserService(client: MockClient(result: User.sampleList))
    let users = try await sut.fetchUsers(page: 1)
    XCTAssertEqual(users.count, 3)
}
```
