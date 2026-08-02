//
//  UserListView.swift
//  Wires the view model to the UI, handling loading / error / data states.
//

import SwiftUI

struct UserListView: View {

    // `@StateObject` creates the view model ONCE and keeps it alive across
    // re-renders. Use @StateObject when THIS view owns the object.
    @StateObject private var viewModel: UserListViewModel

    init(service: UserServiceProtocol) {
        _viewModel = StateObject(wrappedValue: UserListViewModel(service: service))
    }

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Users")
                // `.task` runs an async job when the view appears and cancels it
                // automatically when the view disappears. Perfect for initial loads.
                .task {
                    await viewModel.load()
                }
        }
    }

    // MARK: - State-driven content

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle, .loading:
            ProgressView("Loading…")

        case .loaded(let users):
            List(users) { user in
                VStack(alignment: .leading) {
                    Text(user.fullName).font(.headline)
                    Text(user.email).font(.subheadline).foregroundStyle(.secondary)
                }
            }
            // Pull-to-refresh — the closure is async, List shows the spinner for you.
            .refreshable { await viewModel.refresh() }

        case .failed(let message):
            ContentUnavailableView {
                Label("Something went wrong", systemImage: "wifi.exclamationmark")
            } description: {
                Text(message)
            } actions: {
                Button("Try Again") { Task { await viewModel.load() } }
                    .buttonStyle(.borderedProminent)
            }
        }
    }
}

// MARK: - Preview
//
// Uses the mock service so the preview renders instantly with no network.

#Preview("Loaded") {
    UserListView(service: MockUserService())
}

#Preview("Error") {
    UserListView(service: MockUserService(error: APIError.unauthorized))
}
