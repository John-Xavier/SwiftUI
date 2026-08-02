//
//  CustomEnvironmentKey.swift
//  Inject a plain service through @Environment (no ObservableObject required).
//

import SwiftUI

// Sometimes you want to inject a *service* (not observable state) through the
// environment — e.g. an analytics logger or the UserService. Define a custom
// EnvironmentKey to do it type-safely.

// MARK: - 1. Define a default value

private struct UserServiceKey: EnvironmentKey {
    // The value used when nobody injected one. Provide a safe default
    // (here, a mock) so previews work out of the box.
    static let defaultValue: UserServiceProtocol = MockUserService()
}

// MARK: - 2. Expose it on EnvironmentValues

extension EnvironmentValues {
    var userService: UserServiceProtocol {
        get { self[UserServiceKey.self] }
        set { self[UserServiceKey.self] = newValue }
    }
}

// MARK: - 3. Optional: a convenience modifier for readable injection

extension View {
    func userService(_ service: UserServiceProtocol) -> some View {
        environment(\.userService, service)
    }
}

// MARK: - 4. Inject at the root

struct EnvKeyDemoApp: View {
    var body: some View {
        UsersScreen()
            .userService(UserService(client: APIClient(
                baseURL: URL(string: "https://reqres.in/api")!
            )))
    }
}

// MARK: - 5. Read it anywhere

struct UsersScreen: View {
    // Pulls the injected service (or the default mock in previews).
    @Environment(\.userService) private var service
    @State private var users: [User] = []

    var body: some View {
        List(users) { Text($0.fullName) }
            .task { users = (try? await service.fetchUsers(page: 1)) ?? [] }
    }
}

#Preview {
    // No injection needed — the EnvironmentKey's defaultValue (MockUserService) is used.
    UsersScreen()
}
