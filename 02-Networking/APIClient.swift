//
//  APIClient.swift
//  A generic, reusable async/await network client.
//

import Foundation

/// A protocol so services can depend on an abstraction (and be mocked in tests).
protocol APIClientProtocol {
    /// Sends the endpoint and decodes the JSON response into `T`.
    func request<T: Decodable>(_ endpoint: Endpoint, as type: T.Type) async throws -> T

    /// For requests that return no body (e.g. DELETE → 204).
    func send(_ endpoint: Endpoint) async throws
}

/// Concrete client built on `URLSession`.
struct APIClient: APIClientProtocol {

    let baseURL: URL
    let session: URLSession
    let decoder: JSONDecoder

    /// - Parameters:
    ///   - baseURL: e.g. `URL(string: "https://api.example.com")!`
    ///   - session: injectable so tests can pass a mock (`URLProtocol`).
    ///   - decoder: injectable so you can share date/key strategies.
    init(
        baseURL: URL,
        session: URLSession = .shared,
        decoder: JSONDecoder = {
            let d = JSONDecoder()
            d.keyDecodingStrategy = .convertFromSnakeCase   // auto snake_case → camelCase
            d.dateDecodingStrategy = .iso8601
            return d
        }()
    ) {
        self.baseURL = baseURL
        self.session = session
        self.decoder = decoder
    }

    // MARK: - Decoded request

    func request<T: Decodable>(_ endpoint: Endpoint, as type: T.Type) async throws -> T {
        let data = try await perform(endpoint)
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw APIError.decodingFailed(underlying: error)
        }
    }

    // MARK: - No-content request

    func send(_ endpoint: Endpoint) async throws {
        _ = try await perform(endpoint)
    }

    // MARK: - Core request pipeline
    //
    // 1. Build the URLRequest.
    // 2. Await the network call.
    // 3. Validate the HTTP status code.
    // 4. Return raw Data (decoding happens in the caller).

    private func perform(_ endpoint: Endpoint) async throws -> Data {
        guard let url = endpoint.url(base: baseURL) else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.httpBody = endpoint.body
        endpoint.headers.forEach { request.setValue($1, forHTTPHeaderField: $0) }

        let data: Data
        let response: URLResponse
        do {
            // `URLSession.data(for:)` is the async/await entry point.
            // Structured concurrency cancels this automatically if the parent Task is cancelled.
            (data, response) = try await session.data(for: request)
        } catch {
            throw APIError.requestFailed(underlying: error)
        }

        guard let http = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        switch http.statusCode {
        case 200...299:
            return data
        case 401:
            throw APIError.unauthorized
        default:
            throw APIError.unacceptableStatusCode(http.statusCode)
        }
    }
}
