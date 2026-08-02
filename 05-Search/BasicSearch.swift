//
//  BasicSearch.swift
//  .searchable + live filtering of a local array.
//

import SwiftUI

struct BasicSearch: View {
    private let allUsers = User.sampleList

    // Bound to the search field. Empty string = no filter.
    @State private var query = ""

    // Computed property recomputes whenever `query` changes.
    // For in-memory arrays this is fast enough to do on every keystroke.
    private var filteredUsers: [User] {
        guard !query.isEmpty else { return allUsers }
        return allUsers.filter { user in
            // Case- and diacritic-insensitive match against name OR email.
            user.fullName.localizedCaseInsensitiveContains(query)
            || user.email.localizedCaseInsensitiveContains(query)
        }
    }

    var body: some View {
        NavigationStack {
            List(filteredUsers) { user in
                VStack(alignment: .leading) {
                    Text(user.fullName)
                    Text(user.email).font(.caption).foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Users")
            // The search bar. `prompt` is the placeholder text.
            .searchable(text: $query, prompt: "Search name or email")
            // Show an empty state when a search yields nothing.
            .overlay {
                if filteredUsers.isEmpty {
                    ContentUnavailableView.search(text: query)
                }
            }
        }
    }
}

#Preview {
    BasicSearch()
}
