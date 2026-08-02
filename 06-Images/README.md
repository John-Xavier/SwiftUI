# Images

Loading remote images the right way: use the built-in `AsyncImage` for simple cases, and a **custom cached loader** when you need caching, retries, or reuse across screens.

## Files

- [`AsyncImageExamples.swift`](./AsyncImageExamples.swift) — `AsyncImage` with placeholder, phases, and content styling.
- [`ImageCache.swift`](./ImageCache.swift) — an in-memory (`NSCache`) + disk image cache.
- [`CachedAsyncImage.swift`](./CachedAsyncImage.swift) — a reusable view that loads once and caches.

## When to use what

| Situation | Use |
|-----------|-----|
| Quick, one-off remote image | `AsyncImage` |
| Same image shown across screens / lists | `CachedAsyncImage` (avoids re-downloading) |
| Need retry / disk cache / custom loading | `ImageCache` + `CachedAsyncImage` |

## AsyncImage gotcha

`AsyncImage` does **not** cache beyond `URLSession`'s default policy, and it
re-downloads when the view is recreated (common in `List`). For lists, prefer
the `CachedAsyncImage` here.

## Quick reference

```swift
// Simplest:
AsyncImage(url: url)

// With placeholder + resizing:
AsyncImage(url: url) { image in
    image.resizable().scaledToFill()
} placeholder: {
    ProgressView()
}
.frame(width: 60, height: 60)
.clipShape(Circle())
```
