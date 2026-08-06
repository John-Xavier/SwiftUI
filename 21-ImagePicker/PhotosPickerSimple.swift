//
//  PhotosPickerSimple.swift
//  START HERE — pick ONE photo and show it (iOS 16+).
//
//  PhotosPicker is the modern, built-in way. No Info.plist permission needed,
//  because the picker runs outside your app and only hands back the chosen photo.
//

import SwiftUI
import PhotosUI      // provides PhotosPicker and PhotosPickerItem

struct PhotosPickerSimple: View {
    // What the user picked (a lightweight reference, not the image yet).
    @State private var selectedItem: PhotosPickerItem?

    // The actual image to display, once we've loaded it.
    @State private var selectedImage: Image?

    var body: some View {
        VStack(spacing: 20) {

            // 1. Show the picked image, or a placeholder.
            if let selectedImage {
                selectedImage
                    .resizable()
                    .scaledToFill()
                    .frame(width: 200, height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            } else {
                RoundedRectangle(cornerRadius: 16)
                    .fill(.gray.opacity(0.2))
                    .frame(width: 200, height: 200)
                    .overlay(Image(systemName: "photo").font(.largeTitle).foregroundStyle(.secondary))
            }

            // 2. The picker button. `matching: .images` = photos only (no videos).
            PhotosPicker("Choose a photo", selection: $selectedItem, matching: .images)
                .buttonStyle(.borderedProminent)
        }
        // 3. When the selection changes, load the bytes and make an Image.
        //    Loading is async because the photo may need to be fetched from iCloud.
        .onChange(of: selectedItem) { _, newItem in
            Task {
                // loadTransferable pulls the raw file Data for the picked item.
                if let data = try? await newItem?.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    selectedImage = Image(uiImage: uiImage)
                }
            }
        }
    }
}

#Preview {
    PhotosPickerSimple()
}
