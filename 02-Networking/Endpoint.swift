//
//  Endpoint.swift
//  A lightweight, testable description of an HTTP request.
//

import Foundation

/// HTTP methods we support. Add more as needed.
enum HTTPMethod: String {
    case get    = "GET"
    case post   = "POST"
    case put    = "PUT"
    case patch  = "PATCH"
    case delete = "DELETE"
}

/// Describes *what* to request without knowing *how* to send it.
///
/// Keeping this a plain value type makes requests trivial to build and to
/// assert on in unit tests.
struct Endpoint {
    var path: String                       // e.g. "/users"
    var method: HTTPMethod = .get
    var queryItems: [URLQueryItem] = []     // e.g. ?page=1
    var headers: [String: String] = [:]
    var body: Data? = nil                   // pre-encoded JSON for POST/PUT

    /// Builds a full `URL` against a base URL.
    func url(base: URL) -> URL? {
        var components = URLComponents(
            url: base.appendingPathComponent(path),
            resolvingAgainstBaseURL: false
        )
        if !queryItems.isEmpty {
            components?.queryItems = queryItems
        }
        return components?.url
    }
}

// MARK: - Convenience factories
//
// Feature code reads nicely: `Endpoint.users(page: 2)`.

extension Endpoint {
    static func users(page: Int = 1) -> Endpoint {
        Endpoint(
            path: "/users",
            queryItems: [URLQueryItem(name: "page", value: "\(page)")]
        )
    }

    static func user(id: Int) -> Endpoint {
        Endpoint(path: "/users/\(id)")
    }

    /// Example POST with a JSON body.
    static func createUser(_ user: User) -> Endpoint {
        Endpoint(
            path: "/users",
            method: .post,
            headers: ["Content-Type": "application/json"],
            body: try? JSONEncoder().encode(user)
        )
    }
}
