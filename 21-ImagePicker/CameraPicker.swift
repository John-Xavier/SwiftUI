//
//  CameraPicker.swift
//  ADVANCED — take a photo with the camera.
//
//  SwiftUI has no native camera view, so we wrap UIKit's UIImagePickerController
//  with UIViewControllerRepresentable. This is the standard bridge pattern for
//  using any UIKit controller in SwiftUI.
//
//  ⚠️ Add `NSCameraUsageDescription` to Info.plist or the app crashes.
//  ⚠️ The camera does NOT work in the Simulator — test on a device.
//

import SwiftUI
import UIKit

// MARK: - The UIKit bridge

/// Wraps UIImagePickerController so it can be presented as a SwiftUI `.sheet`.
struct CameraPicker: UIViewControllerRepresentable {
    // The picked image is written back here for the parent view to use.
    @Binding var image: UIImage?
    @Environment(\.dismiss) private var dismiss

    // 1. Create the UIKit controller.
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera        // use .photoLibrary to reuse this for the library
        picker.delegate = context.coordinator
        return picker
    }

    // Nothing to update after creation.
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    // 2. A Coordinator receives the delegate callbacks (UIKit talks to it).
    func makeCoordinator() -> Coordinator { Coordinator(self) }

    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: CameraPicker
        init(_ parent: CameraPicker) { self.parent = parent }

        // Called when the user snaps a photo.
        func imagePickerController(
            _ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
        ) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage          // hand the photo back to SwiftUI
            }
            parent.dismiss()
        }

        // Called when the user taps Cancel.
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}

// MARK: - Using it from a SwiftUI screen

struct CameraExample: View {
    @State private var image: UIImage?
    @State private var showCamera = false

    var body: some View {
        VStack(spacing: 20) {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 300)
            } else {
                Text("No photo yet").foregroundStyle(.secondary)
            }

            Button("Take Photo") { showCamera = true }
                .buttonStyle(.borderedProminent)
        }
        // Present the camera as a full-screen sheet.
        .fullScreenCover(isPresented: $showCamera) {
            CameraPicker(image: $image)
                .ignoresSafeArea()
        }
    }
}

// No #Preview: the camera requires a real device.
