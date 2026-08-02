//
//  BasicList.swift
//  Plain lists, custom rows, and sections.
//

import SwiftUI

// MARK: - 1. The simplest list
//
// `users` is [User], and User is Identifiable, so no `id:` needed.

struct SimpleList: View {
    let users = User.sampleList

    var body: some View {
        List(users) { user in
            Text(user.fullName)
        }
    }
}

// MARK: - 2. A custom row view
//
// Extract rows into their own view for reuse and cleaner previews.

struct UserRow: View {
    let user: User

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "person.circle.fill")
                .font(.largeTitle)
                .foregroundStyle(.tint)

            VStack(alignment: .leading, spacing: 2) {
                Text(user.fullName).font(.headline)
                Text(user.email).font(.subheadline).foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

struct CustomRowList: View {
    var body: some View {
        List(User.sampleList) { UserRow(user: $0) }
            .listStyle(.plain)
    }
}

// MARK: - 3. Sections with headers and footers
//
// Use ForEach inside the List when you need Sections.

struct SectionedList: View {
    // Group users A–M and N–Z as an example.
    private var firstHalf: [User] { Array(User.sampleList.prefix(2)) }
    private var secondHalf: [User] { Array(User.sampleList.dropFirst(2)) }

    var body: some View {
        List {
            Section {
                ForEach(firstHalf) { UserRow(user: $0) }
            } header: {
                Text("A – M")
            } footer: {
                Text("\(firstHalf.count) people")
            }

            Section("N – Z") {
                ForEach(secondHalf) { UserRow(user: $0) }
            }
        }
        .listStyle(.insetGrouped)
    }
}

#Preview("Simple")   { SimpleList() }
#Preview("Custom")   { CustomRowList() }
#Preview("Sections") { SectionedList() }
