//
//  PillsTagsBadges.swift
//  Pills, tags, removable chips, status badges, and count badges.
//

import SwiftUI

// MARK: - 1. Pill / Tag (a rounded, colored label)

struct Pill: View {
    let text: String
    var color: Color = .blue

    var body: some View {
        Text(text)
            .font(.caption.weight(.semibold))
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            // .opacity(0.15) tint keeps it readable in light AND dark mode.
            .background(color.opacity(0.15), in: Capsule())
            .foregroundStyle(color)
    }
}

// MARK: - 2. Removable chip (tag with an "x" to delete)

struct RemovableChip: View {
    let text: String
    var onRemove: () -> Void

    var body: some View {
        HStack(spacing: 6) {
            Text(text).font(.subheadline)
            Button(action: onRemove) {
                Image(systemName: "xmark.circle.fill")
            }
            .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(Color(.secondarySystemBackground), in: Capsule())
    }
}

// MARK: - 3. Status badge (colored dot + label)

struct StatusBadge: View {
    enum Status { case online, away, offline
        var color: Color { switch self { case .online: .green; case .away: .orange; case .offline: .gray } }
        var label: String { switch self { case .online: "Online"; case .away: "Away"; case .offline: "Offline" } }
    }
    let status: Status

    var body: some View {
        HStack(spacing: 6) {
            Circle().fill(status.color).frame(width: 8, height: 8)
            Text(status.label).font(.caption).foregroundStyle(.secondary)
        }
    }
}

// MARK: - 4. Count / notification badge (the little number on an icon)

struct CountBadge: View {
    let count: Int

    var body: some View {
        if count > 0 {
            Text(count > 99 ? "99+" : "\(count)")
                .font(.caption2.bold())
                .foregroundStyle(.white)
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .background(.red, in: Capsule())
        }
    }
}

/// A bell icon with a badge in the corner — the classic use of CountBadge.
struct BadgedIcon: View {
    let systemName: String
    let count: Int

    var body: some View {
        Image(systemName: systemName)
            .font(.title2)
            .overlay(alignment: .topTrailing) {
                CountBadge(count: count)
                    .alignmentGuide(.top) { $0[.top] - 6 }        // nudge outward
                    .alignmentGuide(.trailing) { $0[.trailing] + 6 }
            }
    }
}

// MARK: - Preview

#Preview {
    VStack(alignment: .leading, spacing: 20) {
        HStack { Pill(text: "New", color: .blue); Pill(text: "Sale", color: .red); Pill(text: "Hot", color: .orange) }
        RemovableChip(text: "Swift") {}
        HStack(spacing: 16) { StatusBadge(status: .online); StatusBadge(status: .away); StatusBadge(status: .offline) }
        BadgedIcon(systemName: "bell.fill", count: 5)
    }
    .padding()
}
