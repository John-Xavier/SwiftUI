//
//  ListWithNavigation.swift
//  Tappable list rows that push a detail screen.
//

import SwiftUI

struct UserListNavigation: View {
    let users = User.sampleList

    var body: some View {
        // NavigationStack is the modern (iOS 16+) container for push navigation.
        NavigationStack {
            List(users) { user in
                // NavigationLink wraps a row and pushes `destination` on tap.
                NavigationLink(value: user) {   // value-based link (works with navigationDestination)
                    UserRow(user: user)
                }
            }
            .navigationTitle("Users")
            // Declares: "when a `User` value is pushed, build this screen."
            // Value-based destinations keep row views lightweight and enable
            // programmatic navigation (push a User from anywhere).
            .navigationDestination(for: User.self) { user in
                UserDetail(user: user)
            }
        }
    }
}

struct UserDetail: View {
    let user: User

    var body: some View {
        List {
            LabeledContent("Name",  value: user.fullName)
            LabeledContent("Email", value: user.email)
            LabeledContent("ID",    value: "\(user.id)")
        }
        .navigationTitle(user.firstName)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    UserListNavigation()
}
