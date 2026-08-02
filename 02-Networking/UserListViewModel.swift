//
//  UserListViewModel.swift
//  A @MainActor view model that drives the users screen.
//

import Foundation

/// A finite set of UI states. Modeling the state as an enum makes the view a
/// simple `switch` and makes impossible states unrepresentable (e.g. you can't
/// be "loading" and "error" at the same time).
enum LoadState<Value> {
    case idle
    case loading
    case loaded(Value)
    case failed(String)
}

/// `@MainActor` guarantees every property mutation happens on the main thread,
/// so SwiftUI updates are always safe. `ObservableObject` lets views observe it.
@MainActor
final class UserListViewModel: ObservableObject {

    /// The single source of truth the view renders.
    @Published private(set) var state: LoadState<[User]> = .idle

    private let service: UserServiceProtocol

    /// Dependency-injected service — pass the real one in the app, a mock in previews.
    init(service: UserServiceProtocol) {
        self.service = service
    }

    /// Loads users. Marked `async` so the view can `await` it from `.task`.
    func load() async {
        state = .loading
        do {
            let users = try await service.fetchUsers(page: 1)
            state = .loaded(users)
        } catch {
            // `error.localizedDescription` returns our APIError message.
            state = .failed(error.localizedDescription)
        }
    }

    /// For pull-to-refresh — same work, but doesn't flash the full-screen spinner.
    func refresh() async {
        do {
            let users = try await service.fetchUsers(page: 1)
            state = .loaded(users)
        } catch {
            state = .failed(error.localizedDescription)
        }
    }
}
