//
//  Keychain.swift
//  Securely store secrets (tokens, passwords) — the SIMPLE version first.
//
//  Use the Keychain (NOT UserDefaults) for anything sensitive: auth tokens,
//  passwords, API keys. UserDefaults is plain text on disk; the Keychain is
//  encrypted by the system.
//
//  There's no `import Keychain` — you call the C `Security` framework. The
//  helper below hides that behind three simple methods: save / read / delete.
//

import Foundation
import Security

// MARK: - 1. Simple helper (this is all most apps ever need)

/// A tiny Keychain wrapper for saving Strings (like an auth token) by a key.
///
///   KeychainHelper.save("abc123", for: "authToken")
///   let token = KeychainHelper.read(for: "authToken")   // "abc123"
///   KeychainHelper.delete(for: "authToken")
enum KeychainHelper {

    /// Save (or overwrite) a string for a key.
    @discardableResult
    static func save(_ value: String, for key: String) -> Bool {
        let data = Data(value.utf8)

        // A "query" is a dictionary describing the item. These two keys identify it:
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,  // "a generic secret"
            kSecAttrAccount as String: key                  // our lookup key
        ]

        // Delete any existing item first, so save() also works as "update".
        SecItemDelete(query as CFDictionary)

        // Now add the item with its value.
        var attributes = query
        attributes[kSecValueData as String] = data

        let status = SecItemAdd(attributes as CFDictionary, nil)
        return status == errSecSuccess
    }

    /// Read the string for a key (nil if not found).
    static func read(for key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,      // "give me the value back"
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        guard status == errSecSuccess, let data = result as? Data else { return nil }
        return String(decoding: data, as: UTF8.self)
    }

    /// Delete the item for a key.
    @discardableResult
    static func delete(for key: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess || status == errSecItemNotFound
    }
}

// MARK: - Usage
//
//   // After login:
//   KeychainHelper.save(response.token, for: "authToken")
//
//   // When making a request:
//   if let token = KeychainHelper.read(for: "authToken") {
//       request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//   }
//
//   // On logout:
//   KeychainHelper.delete(for: "authToken")

// ────────────────────────────────────────────────────────────────────────────
// MARK: - 2. ADVANCED (optional): store Codable values + control accessibility
//
// Only reach for this if you need to store a whole object, or restrict WHEN the
// secret is readable (e.g. only after the device is unlocked). Skip on first read.
// ────────────────────────────────────────────────────────────────────────────

extension KeychainHelper {

    /// Save any Codable value (encoded to JSON) securely.
    @discardableResult
    static func save<T: Encodable>(_ value: T, for key: String) -> Bool {
        guard let data = try? JSONEncoder().encode(value) else { return false }

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        SecItemDelete(query as CFDictionary)

        var attributes = query
        attributes[kSecValueData as String] = data
        // Accessibility: only readable after first unlock, never synced/backed up.
        attributes[kSecAttrAccessible as String] = kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly

        return SecItemAdd(attributes as CFDictionary, nil) == errSecSuccess
    }

    /// Read + decode a Codable value.
    static func read<T: Decodable>(_ type: T.Type, for key: String) -> T? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var result: AnyObject?
        guard SecItemCopyMatching(query as CFDictionary, &result) == errSecSuccess,
              let data = result as? Data else { return nil }
        return try? JSONDecoder().decode(T.self, from: data)
    }
}
