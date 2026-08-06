//
//  SimpleUserDefaults.swift
//  START HERE — the simplest way to save small values.
//
//  UserDefaults is a tiny key–value store built into every app. Think of it as
//  a dictionary that survives app restarts. Great for settings and small flags.
//  NOT for large data or secrets (use a database / Keychain for those).
//

import Foundation

// MARK: - 1. The absolute basics: save and read

func simpleUserDefaultsBasics() {

    // `standard` is the shared store every app has for free.
    let defaults = UserDefaults.standard

    // SAVE — set a value for a key (the key is just a string you choose).
    defaults.set("John", forKey: "username")     // String
    defaults.set(true, forKey: "isLoggedIn")     // Bool
    defaults.set(42, forKey: "highScore")        // Int

    // READ — get the value back with the matching type.
    let username = defaults.string(forKey: "username")     // "John"  (String?)
    let isLoggedIn = defaults.bool(forKey: "isLoggedIn")   // true    (defaults to false if missing)
    let highScore = defaults.integer(forKey: "highScore")  // 42      (defaults to 0 if missing)

    // DELETE — remove a value.
    defaults.removeObject(forKey: "username")

    print(username ?? "no name", isLoggedIn, highScore)
}

// MARK: - 2. In SwiftUI, prefer @AppStorage (does the above for you)
//
// @AppStorage reads/writes UserDefaults AND refreshes the UI automatically.
// See AppStorageExample.swift for the full version — but here's the gist:
//
//   @AppStorage("username")   var username = ""      // String
//   @AppStorage("isLoggedIn") var isLoggedIn = false // Bool
//
// Just use `username`/`isLoggedIn` like normal variables — they persist.

// MARK: - 3. Supported types
//
// UserDefaults stores: String, Int, Double, Bool, Date, Data, URL,
// and Arrays/Dictionaries of those. For your OWN types (a struct), encode
// it to Data first — see UserDefaultsWrapper.swift (the advanced file).
