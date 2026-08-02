//
//  GridLayouts.swift
//  LazyVGrid (adaptive & fixed) and the iOS 16 Grid.
//

import SwiftUI

// MARK: - LazyVGrid: adaptive columns (as many as fit)

struct AdaptiveGrid: View {
    // `.adaptive(minimum:)` fits as many columns as possible, each ≥ 100pt.
    private let columns = [GridItem(.adaptive(minimum: 100), spacing: 12)]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(1...20, id: \.self) { i in
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.blue.gradient)
                        .frame(height: 100)
                        .overlay(Text("\(i)").foregroundStyle(.white))
                }
            }
            .padding()
        }
    }
}

// MARK: - LazyVGrid: fixed 3 columns

struct ThreeColumnGrid: View {
    // Exactly three equal-width columns.
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 3)

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(1...12, id: \.self) { i in
                    Text("\(i)")
                        .frame(maxWidth: .infinity, minHeight: 80)
                        .background(.green.opacity(0.3), in: RoundedRectangle(cornerRadius: 8))
                }
            }
            .padding()
        }
    }
}

// MARK: - Grid (iOS 16): true rows & columns, aligned like a table

struct TableGrid: View {
    var body: some View {
        Grid(alignment: .leading, horizontalSpacing: 16, verticalSpacing: 8) {
            GridRow {
                Text("Name").bold()
                Text("Email").bold()
            }
            Divider().gridCellColumns(2)   // span both columns
            ForEach(User.sampleList) { user in
                GridRow {
                    Text(user.fullName)
                    Text(user.email).foregroundStyle(.secondary)
                }
            }
        }
        .padding()
    }
}

#Preview("Adaptive") { AdaptiveGrid() }
#Preview("Fixed 3")  { ThreeColumnGrid() }
#Preview("Grid")     { TableGrid() }
