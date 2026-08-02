//
//  SearchWithScopes.swift
//  Search scopes (segmented filter) and search suggestions.
//

import SwiftUI

struct SearchWithScopes: View {
    private let allUsers = User.sampleList

    @State private var query = ""
    @State private var scope: SearchScope = .all

    // The segmented control options shown under the search bar.
    enum SearchScope: String, CaseIterable {
        case all   = "All"
        case name  = "Name"
        case email = "Email"
    }

    private var filtered: [User] {
        guard !query.isEmpty else { return allUsers }
        return allUsers.filter { user in
            switch scope {
            case .all:
                return user.fullName.localizedCaseInsensitiveContains(query)
                    || user.email.localizedCaseInsensitiveContains(query)
            case .name:
                return user.fullName.localizedCaseInsensitiveContains(query)
            case .email:
                return user.email.localizedCaseInsensitiveContains(query)
            }
        }
    }

    var body: some View {
        NavigationStack {
            List(filtered) { user in
                Text(user.fullName)
            }
            .navigationTitle("Users")
            .searchable(text: $query, prompt: "Search")
            // Scopes render as a segmented control below the search field.
            .searchScopes($scope) {
                ForEach(SearchScope.allCases, id: \.self) { scope in
                    Text(scope.rawValue).tag(scope)
                }
            }
            // Tappable suggestions appear while the field is focused.
            .searchSuggestions {
                ForEach(allUsers.prefix(3)) { user in
                    Text(user.fullName)
                        // Tapping fills the search field with this text.
                        .searchCompletion(user.fullName)
                }
            }
        }
    }
}

#Preview {
    SearchWithScopes()
}
