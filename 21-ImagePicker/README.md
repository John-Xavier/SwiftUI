# Image Picking & Display

Let the user pick a photo from their library (or take one with the camera), show it, and **save it to the file system**.

## Files (simple → advanced)

| Order | File | Level | What it does |
|-------|------|-------|--------------|
| 1 | [`PhotosPickerSimple.swift`](./PhotosPickerSimple.swift) | 🟢 Simple | Pick one photo with `PhotosPicker` and display it — **start here** (iOS 16+, no permissions needed) |
| 2 | [`SaveImageToFiles.swift`](./SaveImageToFiles.swift) | 🟢→🔴 | **Save an image to disk**, load it back, delete; multi-image gallery at the bottom |
| 3 | [`MultiPhotoPicker.swift`](./MultiPhotoPicker.swift) | 🟡 Medium | Pick **multiple** photos into a grid |
| 4 | [`CameraPicker.swift`](./CameraPicker.swift) | 🔴 Advanced | Take a photo with the camera (`UIImagePickerController` bridged via `UIViewControllerRepresentable`) |

## Which to use?

| Need | Use |
|------|-----|
| Pick from photo library | **`PhotosPicker`** (built-in, modern, no Info.plist permission needed) |
| Take a new photo with the camera | `UIImagePickerController` (needs the camera; see `CameraPicker.swift`) |

## PhotosPicker in a nutshell (iOS 16+)

```swift
@State private var selection: PhotosPickerItem?   // what the user picked
@State private var image: Image?                  // the loaded image to show

PhotosPicker("Choose photo", selection: $selection, matching: .images)

// When the pick changes, load its Data and turn it into an Image:
.onChange(of: selection) { _, item in
    Task {
        if let data = try? await item?.loadTransferable(type: Data.self),
           let ui = UIImage(data: data) {
            image = Image(uiImage: ui)
        }
    }
}
```

## Info.plist keys

- **PhotosPicker**: none — it runs out of process, so you never touch the user's library directly.
- **Camera**: add **`NSCameraUsageDescription`** ("Used to take profile photos") or the app crashes when the camera opens.

## Saving to the file system

Images are large — store the **file** in the Documents directory and keep only the
**filename** in your database/model. See [`SaveImageToFiles.swift`](./SaveImageToFiles.swift).

```swift
// Save (returns a filename to remember):
let filename = ImageStorage.save(uiImage)      // "A1B2-…​.jpg"

// Load it back later:
let image = ImageStorage.load(named: filename)  // UIImage?

// Delete:
ImageStorage.delete(named: filename)
```

- Use `jpegData(compressionQuality:)` for photos, `pngData()` when you need transparency.
- Give each file a **unique name** (`UUID().uuidString`) so images don't overwrite each other.
- Persist the filename (in SwiftData/Core Data/UserDefaults), **not** the image bytes.

## Displaying

`Image(uiImage:)` for a picked `UIImage`; make it `.resizable().scaledToFill()`
inside a fixed `.frame(...)` and `.clipShape(...)`. For **remote** images (URLs)
see [../06-Images](../06-Images).
