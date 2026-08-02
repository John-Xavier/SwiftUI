//
//  AsyncImageExamples.swift
//  Built-in AsyncImage: placeholder, phases, styling.
//

import SwiftUI

struct AsyncImageExamples: View {
    let url = URL(string: "https://i.pravatar.cc/300")

    var body: some View {
        VStack(spacing: 24) {

            // 1. Simplest — shows a gray placeholder, then the image.
            AsyncImage(url: url)
                .frame(width: 80, height: 80)

            // 2. Resizable image + custom placeholder.
            //    NOTE: you can only style the image inside the `content` closure.
            AsyncImage(url: url) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 80, height: 80)
            .clipShape(Circle())

            // 3. Phase-based: handle empty / success / failure explicitly.
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    ProgressView()                       // still loading
                case .success(let image):
                    image.resizable().scaledToFit()
                case .failure:
                    Image(systemName: "photo")           // load failed
                        .foregroundStyle(.secondary)
                @unknown default:
                    EmptyView()
                }
            }
            .frame(width: 80, height: 80)
        }
        .padding()
    }
}

#Preview {
    AsyncImageExamples()
}
