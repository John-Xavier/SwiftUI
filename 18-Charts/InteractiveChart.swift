//
//  InteractiveChart.swift
//  Tap/drag to select a value on the chart (iOS 17+ chartXSelection).
//

import SwiftUI
import Charts

struct InteractiveChart: View {
    let data = Array(SalesPoint.sample.prefix(3))

    // iOS 17+: bind the selected X value. SwiftUI updates it as the user drags.
    @State private var selectedMonth: String?

    private var selectedPoint: SalesPoint? {
        data.first { $0.month == selectedMonth }
    }

    var body: some View {
        Chart(data) { point in
            BarMark(
                x: .value("Month", point.month),
                y: .value("Revenue", point.revenue)
            )
            // Dim bars that aren't selected.
            .foregroundStyle(selectedMonth == nil || selectedMonth == point.month
                             ? Color.blue : Color.blue.opacity(0.3))

            // Draw a callout rule + annotation on the selected bar.
            if let selectedPoint, selectedPoint.month == point.month {
                RuleMark(x: .value("Month", selectedPoint.month))
                    .foregroundStyle(.secondary)
                    .annotation(position: .top) {
                        VStack {
                            Text(selectedPoint.month).font(.caption)
                            Text("\(Int(selectedPoint.revenue))").font(.headline)
                        }
                        .padding(6)
                        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 6))
                    }
            }
        }
        // The magic modifier: binds a tap/drag on the X axis to `selectedMonth`.
        .chartXSelection(value: $selectedMonth)
        .frame(height: 260)
        .padding()
    }
}

#Preview {
    InteractiveChart()
}
