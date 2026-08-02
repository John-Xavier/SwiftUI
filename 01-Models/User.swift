//
//  User.swift
//  A simple Codable + Identifiable model.
//
//  Demonstrates the most common model pattern in SwiftUI apps:
//  a value-type struct that can be decoded from JSON and used directly
//  in List / ForEach.
//

import Foundation

/// A user returned by a typical REST API.
///
/// Adopts:
/// - `Codable`     so it can be encoded to / decoded from JSON.
/// - `Identifiable` so `List` / `ForEach` can diff it without a manual `id:` key path.
/// - `Hashable`    so it can be used in a `NavigationStack` path or a `Set`.
struct User: Codable, Identifiable, Hashable {

    let id: Int
    let firstName: String
    let lastName: String
    let email: String
    /// Optional because the API may omit it. Optionals decode to `nil` when the key is missing.
    let avatarURL: URL?

    /// A computed property is NOT part of the JSON — it's derived on the fly.
    /// Computed properties are ignored by Codable automatically.
    var fullName: String {
        "\(firstName) \(lastName)"
    }

    // MARK: - CodingKeys
    //
    // Maps the JSON keys (snake_case) to our Swift property names (camelCase).
    // Every property MUST be listed here once you provide a CodingKeys enum,
    // even the ones whose names already match.
    //
    // JSON example:
    // {
    //   "id": 1,
    //   "first_name": "John",
    //   "last_name": "Xavier",
    //   "email": "john@example.com",
    //   "avatar_url": "https://example.com/a.png"
    // }
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName  = "last_name"
        case email
        case avatarURL = "avatar_url"
    }
}

// MARK: - Sample data for previews & tests

extension User {
    /// Handy static sample so SwiftUI previews don't need a live network call.
    static let sample = User(
        id: 1,
        firstName: "John",
        lastName: "Xavier",
        email: "john@example.com",
        avatarURL: URL(string: "https://i.pravatar.cc/150?img=12")
    )

    static let sampleList: [User] = [
        User(id: 1, firstName: "John",  lastName: "Xavier",  email: "john@example.com",  avatarURL: nil),
        User(id: 2, firstName: "Ada",   lastName: "Lovelace", email: "ada@example.com",   avatarURL: nil),
        User(id: 3, firstName: "Alan",  lastName: "Turing",   email: "alan@example.com",  avatarURL: nil)
    ]
}
