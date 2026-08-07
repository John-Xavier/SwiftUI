//
//  RatingStars.swift
//  Star rating — read-only display and interactive input.
//

import SwiftUI

// MARK: - 1. Read-only star rating (display a score)

struct StarRatingView: View {
    let rating: Double        // e.g. 3.5
    var maximum: Int = 5
    var size: CGFloat = 16
    var color: Color = .yellow

    var body: some View {
        HStack(spacing: 2) {
            ForEach(1...maximum, id: \.self) { index in
                Image(systemName: symbol(for: index))
                    .font(.system(size: size))
                    .foregroundStyle(color)
            }
        }
    }

    // Full, half, or empty star depending on the rating.
    private func symbol(for index: Int) -> String {
        let value = Double(index)
        if rating >= value { return "star.fill" }
        if rating >= value - 0.5 { return "star.leadinghalf.filled" }
        return "star"
    }
}

// MARK: - 2. Interactive star rating (let the user tap to rate)

struct StarRatingInput: View {
    @Binding var rating: Int
    var maximum: Int = 5
    var size: CGFloat = 32

    var body: some View {
        HStack(spacing: 6) {
            ForEach(1...maximum, id: \.self) { index in
                Image(systemName: index <= rating ? "star.fill" : "star")
                    .font(.system(size: size))
                    .foregroundStyle(.yellow)
                    .onTapGesture {
                        // Tap the same star again to clear it (nice touch).
                        rating = (rating == index) ? index - 1 : index
                    }
                    .accessibilityLabel("\(index) star\(index == 1 ? "" : "s")")
            }
        }
        .animation(.easeOut(duration: 0.15), value: rating)
    }
}

// MARK: - Preview

#Preview {
    struct Demo: View {
        @State private var rating = 3
        var body: some View {
            VStack(spacing: 24) {
                StarRatingView(rating: 3.5)
                StarRatingView(rating: 4.0, size: 24, color: .orange)
                StarRatingInput(rating: $rating)
                Text("You rated: \(rating)/5").foregroundStyle(.secondary)
            }
            .padding()
        }
    }
    return Demo()
}
