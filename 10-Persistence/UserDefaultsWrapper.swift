//
//  UserDefaultsWrapper.swift
//  A typed helper for storing Codable values in UserDefaults.
//

import Foundation

/// A tiny, reusable UserDefaults facade for `Codable` values.
///
/// Usage:
///   Defaults.set(user, forKey: "currentUser")
///   let user: User? = Defaults.get(User.self, forKey: "currentUser")
enum Defaults {
    private static let store = UserDefaults.standard

    /// Encode any Codable value to JSON and store it.
    static func set<T: Encodable>(_ value: T, forKey key: String) {
        guard let data = try? JSONEncoder().encode(value) else { return }
        store.set(data, forKey: key)
    }

    /// Decode a Codable value back (returns nil if missing or corrupt).
    static func get<T: Decodable>(_ type: T.Type, forKey key: String) -> T? {
        guard let data = store.data(forKey: key) else { return nil }
        return try? JSONDecoder().decode(T.self, from: data)
    }

    static func remove(forKey key: String) {
        store.removeObject(forKey: key)
    }
}

// MARK: - A @propertyWrapper for even cleaner call sites
//
// Declare a persisted property once, use it like a normal variable:
//   @CodableStorage(key: "currentUser") var currentUser: User?

@propertyWrapper
struct CodableStorage<T: Codable> {
    let key: String
    let defaultValue: T

    var wrappedValue: T {
        get { Defaults.get(T.self, forKey: key) ?? defaultValue }
        set { Defaults.set(newValue, forKey: key) }
    }
}
