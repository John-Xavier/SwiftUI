//
//  UserService.swift
//  A feature service built on top of the generic APIClient.
//

import Foundation

/// A protocol lets view models depend on the *capability*, not the concrete type,
/// so you can inject a mock in previews and tests.
protocol UserServiceProtocol {
    func fetchUsers(page: Int) async throws -> [User]
    func fetchUser(id: Int) async throws -> User
    func createUser(_ user: User) async throws -> User
}

/// Talks to the `/users` endpoints. Contains zero URLSession code — that lives
/// in `APIClient`. This class only knows about *users*.
struct UserService: UserServiceProtocol {

    let client: APIClientProtocol

    init(client: APIClientProtocol) {
        self.client = client
    }

    func fetchUsers(page: Int = 1) async throws -> [User] {
        // The API wraps results in `{ "data": [...] }` → decode PagedResponse, return .data.
        let response = try await client.request(.users(page: page), as: PagedResponse<User>.self)
        return response.data
    }

    func fetchUser(id: Int) async throws -> User {
        try await client.request(.user(id: id), as: User.self)
    }

    func createUser(_ user: User) async throws -> User {
        try await client.request(.createUser(user), as: User.self)
    }
}

// MARK: - Mock for previews & tests

/// A fake service that returns canned data without hitting the network.
struct MockUserService: UserServiceProtocol {
    var usersToReturn: [User] = User.sampleList
    var error: Error? = nil

    func fetchUsers(page: Int) async throws -> [User] {
        if let error { throw error }
        return usersToReturn
    }
    func fetchUser(id: Int) async throws -> User {
        if let error { throw error }
        return usersToReturn.first { $0.id == id } ?? .sample
    }
    func createUser(_ user: User) async throws -> User {
        if let error { throw error }
        return user
    }
}
