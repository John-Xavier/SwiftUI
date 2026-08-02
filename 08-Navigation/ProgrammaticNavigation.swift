//
//  ProgrammaticNavigation.swift
//  A bound path you can push/pop from code — plus pop-to-root and deep-linking.
//

import SwiftUI

// Model your navigation destinations as an enum. Type-safe and exhaustive.
enum Route: Hashable {
    case userDetail(User)
    case settings
    case about
}

struct ProgrammaticNavigation: View {
    // The path IS the navigation stack. Mutating it navigates.
    @State private var path: [Route] = []

    var body: some View {
        NavigationStack(path: $path) {
            List {
                Button("Go to Settings") {
                    path.append(.settings)             // push programmatically
                }
                Button("Deep link: John → About") {
                    // Push MULTIPLE screens at once (deep link).
                    path = [.userDetail(.sample), .about]
                }
            }
            .navigationTitle("Root")
            // One place declares how to build every Route.
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .userDetail(let user):
                    detail(for: user)
                case .settings:
                    settingsScreen
                case .about:
                    Text("About").navigationTitle("About")
                }
            }
        }
    }

    private func detail(for user: User) -> some View {
        VStack(spacing: 16) {
            Text(user.fullName).font(.title)
            Button("Pop to root") { path.removeAll() }   // clear the stack
        }
        .navigationTitle(user.firstName)
    }

    private var settingsScreen: some View {
        List {
            Button("Push About") { path.append(.about) }
            Button("Back") { path.removeLast() }         // pop one
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    ProgrammaticNavigation()
}
