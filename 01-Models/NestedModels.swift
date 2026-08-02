//
//  NestedModels.swift
//  Nested / related objects, arrays, optionals, dates, and enums in Codable.
//

import Foundation

// MARK: - Top-level response wrapper
//
// APIs often wrap their payload: { "page": 1, "data": [ ... ] }.
// Model the wrapper too — decode it, then read `.data`.

/// Generic paginated response. `T` is whatever you're listing (User, Post, …).
struct PagedResponse<T: Codable>: Codable {
    let page: Int
    let perPage: Int
    let total: Int
    let data: [T]

    enum CodingKeys: String, CodingKey {
        case page
        case perPage = "per_page"
        case total
        case data
    }
}

// MARK: - A model with nested objects, arrays, enums and dates

struct Post: Codable, Identifiable, Hashable {
    let id: Int
    let title: String
    let body: String
    let status: Status            // enum decoded from a string
    let tags: [String]            // array of primitives
    let author: Author            // nested object
    let comments: [Comment]       // array of nested objects
    let publishedAt: Date?        // Date decoded via a date strategy (see below)

    /// String-backed enum. Decodes from `"draft"` / `"published"`.
    /// `Codable` on a `String` raw-value enum is automatic.
    enum Status: String, Codable {
        case draft
        case published
        case archived

        /// A fallback keeps decoding from crashing on unknown server values.
        /// (Requires a custom initializer — see `init(from:)` below.)
    }

    struct Author: Codable, Hashable {
        let id: Int
        let name: String
    }

    struct Comment: Codable, Identifiable, Hashable {
        let id: Int
        let text: String
    }

    enum CodingKeys: String, CodingKey {
        case id, title, body, status, tags, author, comments
        case publishedAt = "published_at"
    }
}

// MARK: - Decoding with the right strategies
//
// Configure the decoder once, reuse it everywhere.

enum JSON {
    /// A decoder pre-configured for a typical API:
    /// - ISO 8601 dates ("2026-08-02T10:00:00Z")
    static let decoder: JSONDecoder = {
        let d = JSONDecoder()
        d.dateDecodingStrategy = .iso8601
        return d
    }()

    static let encoder: JSONEncoder = {
        let e = JSONEncoder()
        e.dateEncodingStrategy = .iso8601
        e.outputFormatting = [.prettyPrinted, .sortedKeys]
        return e
    }()
}

// MARK: - Graceful enum decoding (avoid crashes on unknown values)
//
// If the server can send a status your enum doesn't know about, decode
// into a fallback instead of throwing. Add this to any critical enum.

extension Post.Status {
    init(from decoder: Decoder) throws {
        let raw = try decoder.singleValueContainer().decode(String.self)
        self = Post.Status(rawValue: raw) ?? .draft
    }
}
