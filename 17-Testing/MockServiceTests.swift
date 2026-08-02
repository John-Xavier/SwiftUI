//
//  MockServiceTests.swift
//  Test a view model by injecting a mock service (no network).
//
//  Add this file to your app's *test target*. It imports your app module.
//

import XCTest
@testable import YourApp   // ← replace with your module name

@MainActor
final class UserListViewModelTests: XCTestCase {

    // MARK: - Success path

    func test_load_setsLoadedState_withUsers() async {
        // GIVEN a mock service returning three users.
        let mock = MockUserService(usersToReturn: User.sampleList)
        let sut = UserListViewModel(service: mock)   // "sut" = system under test

        // WHEN we load.
        await sut.load()

        // THEN state is .loaded with the expected users.
        guard case .loaded(let users) = sut.state else {
            return XCTFail("Expected .loaded, got \(sut.state)")
        }
        XCTAssertEqual(users.count, 3)
        XCTAssertEqual(users.first?.firstName, "John")
    }

    // MARK: - Failure path

    func test_load_setsFailedState_onError() async {
        // GIVEN a service that throws.
        let mock = MockUserService(error: APIError.unauthorized)
        let sut = UserListViewModel(service: mock)

        // WHEN we load.
        await sut.load()

        // THEN state is .failed with a message.
        guard case .failed(let message) = sut.state else {
            return XCTFail("Expected .failed, got \(sut.state)")
        }
        XCTAssertFalse(message.isEmpty)
    }
}
