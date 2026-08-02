//
//  ImageCache.swift
//  In-memory (NSCache) + disk image cache with an async loader.
//

import SwiftUI

/// A two-tier image cache:
/// 1. Memory (`NSCache`) — fast, cleared automatically under memory pressure.
/// 2. Disk (`FileManager`) — survives app relaunches.
///
/// `actor` gives us thread-safe access without manual locks.
actor ImageLoader {

    static let shared = ImageLoader()

    // NSCache is thread-safe and evicts entries automatically on memory warnings.
    private let memoryCache = NSCache<NSURL, UIImage>()

    // Folder on disk for persisted images.
    private let diskURL: URL

    // De-duplicate concurrent requests for the same URL (avoid double downloads).
    private var inFlight: [URL: Task<UIImage, Error>] = [:]

    init() {
        let caches = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        diskURL = caches.appendingPathComponent("ImageCache", isDirectory: true)
        try? FileManager.default.createDirectory(at: diskURL, withIntermediateDirectories: true)
    }

    /// Returns a cached image or downloads it. Safe to call from many places at once.
    func image(for url: URL) async throws -> UIImage {
        // 1. Memory hit?
        if let cached = memoryCache.object(forKey: url as NSURL) {
            return cached
        }

        // 2. Disk hit?
        let fileURL = diskPath(for: url)
        if let data = try? Data(contentsOf: fileURL), let image = UIImage(data: data) {
            memoryCache.setObject(image, forKey: url as NSURL)
            return image
        }

        // 3. Already downloading this URL? Await the same task.
        if let existing = inFlight[url] {
            return try await existing.value
        }

        // 4. Start a fresh download.
        let task = Task { () -> UIImage in
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let image = UIImage(data: data) else {
                throw URLError(.cannotDecodeContentData)
            }
            // Persist to both tiers.
            memoryCache.setObject(image, forKey: url as NSURL)
            try? data.write(to: fileURL)
            return image
        }
        inFlight[url] = task

        defer { inFlight[url] = nil }   // clean up once done
        return try await task.value
    }

    // Map a remote URL to a stable on-disk filename.
    private func diskPath(for url: URL) -> URL {
        // Hashing avoids illegal filename characters.
        let name = String(url.absoluteString.hashValue, radix: 16)
        return diskURL.appendingPathComponent(name)
    }
}
