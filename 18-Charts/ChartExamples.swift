//
//  ChartExamples.swift
//  Bar, line, area, and multi-series charts with Swift Charts (iOS 16+).
//

import SwiftUI
import Charts

// MARK: - Data model

struct SalesPoint: Identifiable {
    let id = UUID()
    let month: String
    let revenue: Double
    let category: String   // used for multi-series coloring

    static let sample: [SalesPoint] = [
        .init(month: "Jan", revenue: 120, category: "Online"),
        .init(month: "Feb", revenue: 180, category: "Online"),
        .init(month: "Mar", revenue: 150, category: "Online"),
        .init(month: "Jan", revenue: 90,  category: "Retail"),
        .init(month: "Feb", revenue: 110, category: "Retail"),
        .init(month: "Mar", revenue: 200, category: "Retail")
    ]
}

// MARK: - Bar chart

struct BarChartExample: View {
    let data = Array(SalesPoint.sample.prefix(3))   // one series

    var body: some View {
        Chart(data) { point in
            BarMark(
                x: .value("Month", point.month),
                y: .value("Revenue", point.revenue)
            )
            .foregroundStyle(.blue.gradient)
        }
        .frame(height: 240)
        .padding()
    }
}

// MARK: - Line chart with points + smoothing

struct LineChartExample: View {
    let data = Array(SalesPoint.sample.prefix(3))

    var body: some View {
        Chart(data) { point in
            LineMark(
                x: .value("Month", point.month),
                y: .value("Revenue", point.revenue)
            )
            .interpolationMethod(.catmullRom)          // smooth curve
            .symbol(Circle())                          // dot at each data point
        }
        .chartYScale(domain: 0...250)                  // fixed Y range
        .frame(height: 240)
        .padding()
    }
}

// MARK: - Multi-series (one line per category, auto legend)

struct MultiSeriesChart: View {
    let data = SalesPoint.sample

    var body: some View {
        Chart(data) { point in
            LineMark(
                x: .value("Month", point.month),
                y: .value("Revenue", point.revenue)
            )
            // One line + color + legend entry per category, automatically.
            .foregroundStyle(by: .value("Channel", point.category))
        }
        .chartLegend(position: .bottom)
        .frame(height: 240)
        .padding()
    }
}

#Preview("Bar")   { BarChartExample() }
#Preview("Line")  { LineChartExample() }
#Preview("Multi") { MultiSeriesChart() }
