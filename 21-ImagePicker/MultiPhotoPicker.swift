//
//  MultiPhotoPicker.swift
//  Pick MULTIPLE photos into a grid (iOS 16+).
//
//  Same idea as the simple version, but `selection` is an array and we set a
//  `maxSelectionCount`.
//

import SwiftUI
import PhotosUI

struct MultiPhotoPicker: View {
    // Now an ARRAY of picked items.
    @State private var selectedItems: [PhotosPickerItem] = []

    // The loaded images to show.
    @State private var images: [Image] = []

    private let columns = [GridItem(.adaptive(minimum: 100), spacing: 8)]

    var body: some View {
        VStack {
            PhotosPicker(
                "Select photos",
                selection: $selectedItems,
                maxSelectionCount: 5,      // cap it (omit for unlimited)
                matching: .images
            )
            .buttonStyle(.borderedProminent)

            ScrollView {
                LazyVGrid(columns: columns, spacing: 8) {
                    ForEach(Array(images.enumerated()), id: \.offset) { _, image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
                .padding()
            }
        }
        .onChange(of: selectedItems) { _, items in
            // Reload the whole set whenever the selection changes.
            Task {
                var loaded: [Image] = []
                for item in items {
                    if let data = try? await item.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data) {
                        loaded.append(Image(uiImage: uiImage))
                    }
                }
                images = loaded
            }
        }
    }
}

#Preview {
    MultiPhotoPicker()
}
