# Combine

Apple's reactive framework for processing values over time (publishers → operators → subscribers). In modern SwiftUI much of what Combine did is now handled by `async/await`, but Combine is still the best tool for a few jobs.

## When Combine still shines (vs async/await)

| Use Combine for | Why |
|-----------------|-----|
| Debouncing text input | `.debounce` operator is one line |
| Reacting to a stream of values over time | Timers, `NotificationCenter`, multiple `@Published` |
| Combining several publishers | `combineLatest`, `merge`, `zip` |
| Form validation across many fields | Chain `@Published` → validity publisher |

> For a single request/response, prefer **async/await** ([../02-Networking](../02-Networking)) — it's simpler.

## Files

- [`CombineBasics.swift`](./CombineBasics.swift) — publishers, operators, `sink`, `@Published`, `store(in:)`.
- [`DebouncedSearchCombine.swift`](./DebouncedSearchCombine.swift) — the classic debounced search, Combine-style.
- [`CombineNetworking.swift`](./CombineNetworking.swift) — `URLSession.dataTaskPublisher` → decode → UI.

## Core vocabulary

```
Publisher   emits values over time      (e.g. $searchText, dataTaskPublisher)
Operator    transforms the stream       (.map, .filter, .debounce, .removeDuplicates)
Subscriber  receives values             (.sink, .assign)
Cancellable store it, or the sub dies   (var bag = Set<AnyCancellable>())
```

## The one rule that trips everyone up

**You must retain the subscription** or it's cancelled immediately:

```swift
private var cancellables = Set<AnyCancellable>()

publisher
    .sink { value in /* ... */ }
    .store(in: &cancellables)   // ← without this, nothing happens
```

## Always deliver UI updates on the main thread

```swift
.receive(on: DispatchQueue.main)   // before .sink/.assign that touches the UI
```
