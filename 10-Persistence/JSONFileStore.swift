//
//  JSONFileStore.swift
//  Save / load Codable values as JSON files in the Documents directory.
//
//  Best for lists and documents that are too big for UserDefaults but don't
//  need a database.
//

import Foundation

enum JSONFileStore {

    /// The app's Documents directory — backed up and user-visible via Files (if configured).
    private static var documents: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    private static func url(for filename: String) -> URL {
        documents.appendingPathComponent(filename)
    }

    /// Encode `value` to JSON and write it atomically.
    static func save<T: Encodable>(_ value: T, to filename: String) throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try encoder.encode(value)
        // `.atomic` writes to a temp file then renames — no half-written files on crash.
        try data.write(to: url(for: filename), options: [.atomic])
    }

    /// Load and decode a JSON file. Throws if the file is missing or malformed.
    static func load<T: Decodable>(_ type: T.Type = T.self, from filename: String) throws -> T {
        let data = try Data(contentsOf: url(for: filename))
        return try JSONDecoder().decode(T.self, from: data)
    }

    /// Load, returning nil instead of throwing when the file doesn't exist yet.
    static func loadIfExists<T: Decodable>(_ type: T.Type = T.self, from filename: String) -> T? {
        try? load(type, from: filename)
    }

    static func delete(_ filename: String) throws {
        try FileManager.default.removeItem(at: url(for: filename))
    }
}

// MARK: - Example
//
//   try JSONFileStore.save(User.sampleList, to: "users.json")
//   let users = JSONFileStore.loadIfExists([User].self, from: "users.json") ?? []
