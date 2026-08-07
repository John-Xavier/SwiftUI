//
//  Avatars.swift
//  Circle avatars, initials fallback, status dot, and overlapping stacks.
//

import SwiftUI

// MARK: - 1. Initials avatar (no image needed — great as a fallback)

struct InitialsAvatar: View {
    let name: String
    var size: CGFloat = 44

    // "John Xavier" -> "JX"
    private var initials: String {
        let parts = name.split(separator: " ")
        let letters = parts.prefix(2).compactMap { $0.first }
        return String(letters).uppercased()
    }

    // Pick a stable color from the name so each person keeps the same color.
    private var color: Color {
        let palette: [Color] = [.blue, .green, .orange, .purple, .pink, .teal]
        return palette[abs(name.hashValue) % palette.count]
    }

    var body: some View {
        Text(initials)
            .font(.system(size: size * 0.4, weight: .semibold))
            .foregroundStyle(.white)
            .frame(width: size, height: size)
            .background(color.gradient, in: Circle())
    }
}

// MARK: - 2. Image avatar (falls back to initials while loading / on failure)

struct Avatar: View {
    let url: URL?
    let name: String
    var size: CGFloat = 44

    var body: some View {
        AsyncImage(url: url) { image in
            image.resizable().scaledToFill()
        } placeholder: {
            InitialsAvatar(name: name, size: size)   // graceful fallback
        }
        .frame(width: size, height: size)
        .clipShape(Circle())
    }
}

// MARK: - 3. Avatar with a status dot (online indicator)

struct AvatarWithStatus: View {
    let name: String
    var isOnline: Bool
    var size: CGFloat = 44

    var body: some View {
        InitialsAvatar(name: name, size: size)
            .overlay(alignment: .bottomTrailing) {
                Circle()
                    .fill(isOnline ? .green : .gray)
                    .frame(width: size * 0.28, height: size * 0.28)
                    // A ring so the dot reads against any avatar color.
                    .overlay(Circle().stroke(Color(.systemBackground), lineWidth: 2))
            }
    }
}

// MARK: - 4. Overlapping avatar stack ("+3 others")

struct AvatarStack: View {
    let names: [String]
    var max: Int = 3
    var size: CGFloat = 40

    var body: some View {
        let shown = names.prefix(max)
        let overflow = names.count - shown.count

        HStack(spacing: -size * 0.35) {          // negative spacing = overlap
            ForEach(Array(shown.enumerated()), id: \.offset) { _, name in
                InitialsAvatar(name: name, size: size)
                    .overlay(Circle().stroke(Color(.systemBackground), lineWidth: 2))
            }
            if overflow > 0 {
                Text("+\(overflow)")
                    .font(.caption.bold())
                    .frame(width: size, height: size)
                    .background(.gray, in: Circle())
                    .foregroundStyle(.white)
                    .overlay(Circle().stroke(Color(.systemBackground), lineWidth: 2))
            }
        }
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 24) {
        HStack(spacing: 16) {
            InitialsAvatar(name: "John Xavier")
            AvatarWithStatus(name: "Ada Lovelace", isOnline: true)
            AvatarWithStatus(name: "Alan Turing", isOnline: false)
        }
        AvatarStack(names: ["John Xavier", "Ada Lovelace", "Alan Turing", "Grace Hopper", "Linus T"])
    }
    .padding()
}
