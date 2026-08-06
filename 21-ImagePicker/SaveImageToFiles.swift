//
//  SaveImageToFiles.swift
//  Save a picked/captured image to the file system, then load it back.
//
//  Why files (not UserDefaults)? Images are large. Store the IMAGE in the
//  Documents folder and, if you use a database, save only the FILENAME there.
//

import SwiftUI

// MARK: - 1. Simple helper — save / load / delete ONE image

/// Saves images to the app's Documents directory as JPEG files.
///
///   let name = ImageStorage.save(uiImage)          // "A1B2....jpg"
///   let image = ImageStorage.load(named: name)      // UIImage?
///   ImageStorage.delete(named: name)
enum ImageStorage {

    /// The app's Documents folder — persists across launches, per-user.
    private static var documents: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    /// Save a UIImage as a JPEG. Returns the filename to keep (e.g. in your model),
    /// or nil if it couldn't be encoded/written.
    static func save(_ image: UIImage, quality: CGFloat = 0.8) -> String? {
        // 1. Turn the image into JPEG bytes. (Use image.pngData() to keep transparency.)
        guard let data = image.jpegData(compressionQuality: quality) else { return nil }

        // 2. Make a unique filename so images never overwrite each other.
        let filename = UUID().uuidString + ".jpg"
        let fileURL = documents.appendingPathComponent(filename)

        // 3. Write the bytes to disk.
        do {
            try data.write(to: fileURL)
            return filename          // store THIS in your database/model
        } catch {
            print("Save failed: \(error)")
            return nil
        }
    }

    /// Load an image back by its filename.
    static func load(named filename: String) -> UIImage? {
        let fileURL = documents.appendingPathComponent(filename)
        guard let data = try? Data(contentsOf: fileURL) else { return nil }
        return UIImage(data: data)
    }

    /// Delete an image file.
    static func delete(named filename: String) {
        let fileURL = documents.appendingPathComponent(filename)
        try? FileManager.default.removeItem(at: fileURL)
    }
}

// MARK: - 2. Example: pick a photo, save it, and reload it from disk

struct SaveImageExample: View {
    @State private var savedFilename: String?     // this is what you'd persist
    @State private var loadedImage: UIImage?

    var body: some View {
        VStack(spacing: 20) {
            if let loadedImage {
                Image(uiImage: loadedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 250)
            } else {
                Text("No saved image").foregroundStyle(.secondary)
            }

            // Pretend `someUIImage` came from PhotosPicker / camera (see other files here).
            Button("Save a sample image") {
                let sample = UIImage(systemName: "photo")!   // stand-in for a real photo
                if let name = ImageStorage.save(sample) {
                    savedFilename = name
                    // Reload it from disk to prove it persisted.
                    loadedImage = ImageStorage.load(named: name)
                }
            }
            .buttonStyle(.borderedProminent)

            if let savedFilename {
                Button("Delete saved image", role: .destructive) {
                    ImageStorage.delete(named: savedFilename)
                    self.savedFilename = nil
                    loadedImage = nil
                }
            }
        }
        .padding()
    }
}

// ────────────────────────────────────────────────────────────────────────────
// MARK: - 3. ADVANCED (optional): save MANY images and list them back
// ────────────────────────────────────────────────────────────────────────────

extension ImageStorage {

    /// The folder every saved image lives in.
    private static var imagesFolder: URL {
        let url = documents.appendingPathComponent("SavedImages", isDirectory: true)
        // Create it once if it doesn't exist yet.
        try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
        return url
    }

    /// Save into the dedicated SavedImages folder (keeps Documents tidy).
    static func saveToImagesFolder(_ image: UIImage) -> String? {
        guard let data = image.jpegData(compressionQuality: 0.8) else { return nil }
        let filename = UUID().uuidString + ".jpg"
        do {
            try data.write(to: imagesFolder.appendingPathComponent(filename))
            return filename
        } catch { return nil }
    }

    /// List every saved image's filename (e.g. to show a gallery).
    static func allImageFilenames() -> [String] {
        let contents = try? FileManager.default.contentsOfDirectory(
            at: imagesFolder,
            includingPropertiesForKeys: nil
        )
        return (contents ?? []).map(\.lastPathComponent)
    }

    /// Load an image from the SavedImages folder.
    static func loadFromImagesFolder(named filename: String) -> UIImage? {
        let url = imagesFolder.appendingPathComponent(filename)
        guard let data = try? Data(contentsOf: url) else { return nil }
        return UIImage(data: data)
    }
}

#Preview {
    SaveImageExample()
}
