# Swift Charts

`import Charts` (iOS 16+) gives you declarative, SwiftUI-native charts. You describe marks (`BarMark`, `LineMark`, …) over your data and Charts handles axes, scaling, and legends.

## Files

- [`ChartExamples.swift`](./ChartExamples.swift) — bar, line, area, and point charts from a `Codable`-friendly data model.
- [`InteractiveChart.swift`](./InteractiveChart.swift) — drag to select a value (`chartOverlay` + `chartXSelection`).

## The core idea

```swift
Chart(salesData) { item in
    BarMark(
        x: .value("Month", item.month),
        y: .value("Revenue", item.revenue)
    )
}
```

- **`Chart { }`** is the container.
- **Marks** (`BarMark`, `LineMark`, `AreaMark`, `PointMark`, `RuleMark`) are the data-driven shapes.
- **`.value("Label", keyPath)`** ties a data field to an axis and names it for accessibility/tooltips.

## Common customizations

| Want | Modifier |
|------|----------|
| Color series by category | `.foregroundStyle(by: .value("Type", item.type))` |
| Custom axis | `.chartXAxis { AxisMarks(...) }` |
| Fixed Y range | `.chartYScale(domain: 0...100)` |
| Smooth line | `.interpolationMethod(.catmullRom)` |
| Legend position | `.chartLegend(position: .bottom)` |

## Multiple series

Give each `LineMark` a `.foregroundStyle(by:)` and Charts draws one line per
category with an automatic legend — no manual color management.

## Accessibility

Swift Charts is accessible by default: each mark is exposed to VoiceOver using
your `.value("…")` labels. Add `.accessibilityLabel`/`.accessibilityValue` on
marks for richer descriptions. See [../19-Accessibility](../19-Accessibility).
