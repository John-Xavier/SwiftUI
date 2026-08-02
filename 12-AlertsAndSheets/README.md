# Alerts & Sheets

Modal presentations: alerts, confirmation dialogs, sheets, and full-screen covers.

## Files

- [`AlertsAndDialogs.swift`](./AlertsAndDialogs.swift) — `.alert` (incl. text field) and `.confirmationDialog`.
- [`SheetsAndCovers.swift`](./SheetsAndCovers.swift) — `.sheet`, `.fullScreenCover`, `item:`-based sheets, detents.

## Presentation modifiers

| Modifier | Looks like | Use for |
|----------|-----------|---------|
| `.alert` | Centered dialog | Errors, confirmations with 1–2 actions |
| `.confirmationDialog` | Action sheet from bottom | A list of choices (e.g. Delete / Cancel) |
| `.sheet` | Card sliding up (dismissable) | Self-contained tasks; supports detents |
| `.fullScreenCover` | Full-screen modal | Onboarding, login, media |

## Two ways to trigger

```swift
// 1. Boolean flag:
.sheet(isPresented: $showSheet) { EditView() }

// 2. Optional item (also PASSES data to the sheet) — preferred when you present
//    a sheet "for" a specific model:
.sheet(item: $selectedUser) { user in UserDetail(user: user) }
```

Using `item:` avoids the classic bug where a boolean flips true before the
data is set, showing a sheet with stale/nil data.

## Sheet detents (iOS 16+)

```swift
.sheet(isPresented: $show) {
    EditView()
        .presentationDetents([.medium, .large])   // half & full height
        .presentationDragIndicator(.visible)
}
```
