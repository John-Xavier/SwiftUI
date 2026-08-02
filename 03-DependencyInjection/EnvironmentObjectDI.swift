//
//  EnvironmentObjectDI.swift
//  Share one observable object across a whole view subtree.
//

import SwiftUI

/// App-wide session state. One instance is shared by every view that reads it.
@MainActor
final class SessionStore: ObservableObject {
    @Published var currentUser: User?
    @Published var isLoggedIn: Bool = false

    func logIn(as user: User) {
        currentUser = user
        isLoggedIn = true
    }

    func logOut() {
        currentUser = nil
        isLoggedIn = false
    }
}

// MARK: - Provide it once, near the root

@main
struct MyApp: App {
    // The App owns the single instance with @StateObject.
    @StateObject private var session = SessionStore()

    var body: some Scene {
        WindowGroup {
            RootView()
                // Inject into the environment — every descendant can now read it.
                .environmentObject(session)
        }
    }
}

// MARK: - Consume it anywhere in the subtree

struct RootView: View {
    // No init parameter needed — SwiftUI finds it in the environment.
    // ⚠️ Crashes at runtime if no ancestor injected a SessionStore.
    @EnvironmentObject private var session: SessionStore

    var body: some View {
        if session.isLoggedIn {
            HomeView()
        } else {
            LoginView()
        }
    }
}

struct LoginView: View {
    @EnvironmentObject private var session: SessionStore

    var body: some View {
        Button("Log in as John") {
            session.logIn(as: .sample)   // mutating the shared object re-renders observers
        }
    }
}

struct HomeView: View {
    @EnvironmentObject private var session: SessionStore

    var body: some View {
        VStack {
            Text("Welcome, \(session.currentUser?.firstName ?? "friend")")
            Button("Log out") { session.logOut() }
        }
    }
}

// MARK: - Preview MUST re-inject the object or it will crash

#Preview {
    RootView()
        .environmentObject(SessionStore())
}
