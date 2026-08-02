//
//  SwiftTestingExample.swift
//  The same tests using the new Swift Testing framework (Xcode 16+).
//
//  Swift Testing replaces XCTest's `XCTAssert*` with `#expect`/`#require`
//  and uses `@Test` instead of `func testXxx()`.
//

import Testing
@testable import YourApp   // ← replace with your module name

// A `@Suite` groups related tests (optional — plain @Test functions work too).
@Suite("User service")
struct UserServiceTests {

    // `@Test` marks a test. Async/throws are supported directly.
    @Test("fetchUsers returns the mocked users")
    func fetchUsersReturnsUsers() async throws {
        let service = MockUserService(usersToReturn: User.sampleList)

        let users = try await service.fetchUsers(page: 1)

        // #expect is the assertion. On failure it prints the evaluated expression.
        #expect(users.count == 3)
        #expect(users.first?.firstName == "John")
    }

    @Test("fetchUsers throws when the service errors")
    func fetchUsersThrows() async {
        let service = MockUserService(error: APIError.unauthorized)

        // #expect(throws:) asserts the closure throws the given error type.
        await #expect(throws: APIError.self) {
            try await service.fetchUsers(page: 1)
        }
    }

    // Parameterized tests: run the same body for each argument.
    @Test("full name is composed correctly", arguments: [
        (User(id: 1, firstName: "Ada", lastName: "Lovelace", email: "a@b.com", avatarURL: nil), "Ada Lovelace"),
        (User(id: 2, firstName: "Alan", lastName: "Turing",  email: "a@t.com", avatarURL: nil), "Alan Turing")
    ])
    func fullName(user: User, expected: String) {
        #expect(user.fullName == expected)
    }
}
