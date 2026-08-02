//
//  APIError.swift
//  A typed error enum for the networking layer.
//

import Foundation

/// All the ways a network request can fail, mapped to user-friendly messages.
///
/// Conforming to `LocalizedError` means `error.localizedDescription` returns
/// our `errorDescription` — handy for showing in an alert.
enum APIError: LocalizedError {
    case invalidURL
    case requestFailed(underlying: Error)      // transport-level (no connection, timeout…)
    case invalidResponse                       // response wasn't an HTTPURLResponse
    case unacceptableStatusCode(Int)           // e.g. 404, 500
    case decodingFailed(underlying: Error)     // JSON didn't match the model
    case unauthorized                          // 401 — token missing/expired

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL was malformed."
        case .requestFailed:
            return "Couldn't reach the server. Check your connection and try again."
        case .invalidResponse:
            return "The server sent an unexpected response."
        case .unacceptableStatusCode(let code):
            return "The server responded with an error (\(code))."
        case .decodingFailed:
            return "Couldn't read the server's response."
        case .unauthorized:
            return "Your session has expired. Please sign in again."
        }
    }
}
