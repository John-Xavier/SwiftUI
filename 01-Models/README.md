# Models

Model types are the plain-data layer of your app — the structs/classes that mirror JSON, database rows, or app state.

## Key ideas

- **Prefer `struct` over `class`** for value semantics (thread-safe copies, no shared-reference bugs). Use a `class` only when you need reference identity or `@Observable`.
- **`Codable`** = `Encodable` + `Decodable`. Adopt it to convert to/from JSON automatically.
- **`Identifiable`** gives each model a stable `id`, required by `List`/`ForEach` for diffing.
- **`CodingKeys`** map snake_case JSON (`first_name`) to camelCase Swift (`firstName`).
- Use a **`JSONDecoder.keyDecodingStrategy = .convertFromSnakeCase`** to avoid writing `CodingKeys` by hand for simple cases.

## Files

- [`User.swift`](./User.swift) — simple `Codable` + `Identifiable` model with `CodingKeys`.
- [`NestedModels.swift`](./NestedModels.swift) — nested/related objects, arrays, optionals, dates.

## When to use what

| Need | Use |
|------|-----|
| Value type, most models | `struct` |
| Observable shared state (iOS 17+) | `@Observable class` |
| Custom JSON key names | `CodingKeys` enum |
| Automatic snake_case mapping | `decoder.keyDecodingStrategy` |
