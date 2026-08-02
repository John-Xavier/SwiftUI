//
//  CachedAsyncImage.swift
//  A reusable view that loads a remote image through ImageLoader (cached).
//

import SwiftUI

/// Drop-in replacement for AsyncImage that uses our two-tier cache, so the same
/// image isn't re-downloaded when rows scroll back into view.
struct CachedAsyncImage: View {
    let url: URL?

    // View-local state for the loaded image and loading flag.
    @State private var image: UIImage?
    @State private var isLoading = false

    var body: some View {
        Group {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else if isLoading {
                ProgressView()
            } else {
                // Fallback shown before loading starts or on failure.
                Image(systemName: "photo")
                    .foregroundStyle(.secondary)
            }
        }
        // `.task(id:)` restarts the load if the URL changes (important in reused
        // list rows). It also cancels automatically when the view disappears.
        .task(id: url) {
            await load()
        }
    }

    private func load() async {
        guard let url else { return }
        isLoading = true
        defer { isLoading = false }
        image = try? await ImageLoader.shared.image(for: url)
    }
}

// MARK: - Usage in a list (the payoff: no re-downloads on scroll)

struct AvatarListExample: View {
    let users = User.sampleList

    var body: some View {
        List(users) { user in
            HStack {
                CachedAsyncImage(url: URL(string: "https://i.pravatar.cc/100?u=\(user.id)"))
                    .frame(width: 44, height: 44)
                    .clipShape(Circle())
                Text(user.fullName)
            }
        }
    }
}

#Preview {
    AvatarListExample()
}
