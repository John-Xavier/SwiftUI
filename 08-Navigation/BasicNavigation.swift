//
//  BasicNavigation.swift
//  NavigationLink + navigationDestination (iOS 16+).
//

import SwiftUI

struct BasicNavigation: View {
    var body: some View {
        // NavigationStack is the container. Everything pushed lives inside it.
        NavigationStack {
            List {
                // Style 1: inline destination — good for one-offs.
                NavigationLink("Static Screen") {
                    Text("I was pushed inline.")
                        .navigationTitle("Static")
                }

                // Style 2: value-based links — preferred, enables programmatic nav.
                Section("Users") {
                    ForEach(User.sampleList) { user in
                        NavigationLink(user.fullName, value: user)
                    }
                }
            }
            .navigationTitle("Home")
            // Register a builder for any `User` value pushed anywhere in this stack.
            .navigationDestination(for: User.self) { user in
                Text("Detail for \(user.fullName)")
                    .navigationTitle(user.firstName)
            }
        }
    }
}

#Preview {
    BasicNavigation()
}
