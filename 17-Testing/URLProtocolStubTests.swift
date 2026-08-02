//
//  URLProtocolStubTests.swift
//  Test the REAL APIClient by stubbing URLSession with a custom URLProtocol.
//
//  This exercises actual JSON decoding and status-code handling — no server.
//

import XCTest
@testable import YourApp   // ← replace with your module name

// MARK: - The stub: intercepts every request the session makes

final class URLProtocolStub: URLProtocol {
    /// Set this before each test: return (data, statusCode) or throw.
    static var stubResponse: (Data, Int)?
    static var stubError: Error?

    // Intercept ALL requests.
    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

    override func startLoading() {
        if let error = Self.stubError {
            client?.urlProtocol(self, didFailWithError: error)
            return
        }
        if let (data, status) = Self.stubResponse {
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: status,
                httpVersion: nil,
                headerFields: nil
            )!
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
        }
        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}

// MARK: - Building a URLSession that uses the stub

private func makeStubbedClient() -> APIClient {
    let config = URLSessionConfiguration.ephemeral
    config.protocolClasses = [URLProtocolStub.self]     // <- inject the stub
    let session = URLSession(configuration: config)
    return APIClient(baseURL: URL(string: "https://test.example.com")!, session: session)
}

// MARK: - Tests

final class APIClientTests: XCTestCase {

    override func tearDown() {
        URLProtocolStub.stubResponse = nil
        URLProtocolStub.stubError = nil
        super.tearDown()
    }

    func test_request_decodesJSON_on200() async throws {
        // GIVEN the "server" returns valid JSON, 200.
        let json = """
        { "page": 1, "per_page": 6, "total": 1, "data": [
            { "id": 1, "first_name": "John", "last_name": "Xavier", "email": "j@x.com" }
        ]}
        """.data(using: .utf8)!
        URLProtocolStub.stubResponse = (json, 200)

        // WHEN we request.
        let sut = makeStubbedClient()
        let page: PagedResponse<User> = try await sut.request(.users(), as: PagedResponse<User>.self)

        // THEN it decodes correctly.
        XCTAssertEqual(page.data.first?.firstName, "John")
    }

    func test_request_throwsUnauthorized_on401() async {
        URLProtocolStub.stubResponse = (Data(), 401)
        let sut = makeStubbedClient()

        do {
            _ = try await sut.request(.users(), as: PagedResponse<User>.self)
            XCTFail("Expected to throw")
        } catch let error as APIError {
            guard case .unauthorized = error else {
                return XCTFail("Expected .unauthorized, got \(error)")
            }
        } catch {
            XCTFail("Wrong error type: \(error)")
        }
    }
}
