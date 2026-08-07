//
//  Buttons.swift
//  The most-used button styles + a loading button.
//
//  Best practice: put styling in a `ButtonStyle` (not copy-pasted modifiers).
//  You get press feedback for free and can restyle every button in one place.
//

import SwiftUI

// MARK: - Design tokens (define once, reuse everywhere)

enum Theme {
    static let cornerRadius: CGFloat = 12
    static let spacing: CGFloat = 12
    static let accent = Color.blue
}

// MARK: - 1. Primary (filled) button style

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)          // full-width; remove for hug-content
            .padding(.vertical, 14)
            .background(Theme.accent, in: RoundedRectangle(cornerRadius: Theme.cornerRadius))
            // `isPressed` gives instant tactile feedback.
            .opacity(configuration.isPressed ? 0.7 : 1)
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}

// MARK: - 2. Secondary (outline) button style

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundStyle(Theme.accent)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: Theme.cornerRadius)
                    .stroke(Theme.accent, lineWidth: 1.5)
            )
            .opacity(configuration.isPressed ? 0.6 : 1)
    }
}

// MARK: - 3. Destructive style (for delete actions)

struct DestructiveButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(.red, in: RoundedRectangle(cornerRadius: Theme.cornerRadius))
            .opacity(configuration.isPressed ? 0.7 : 1)
    }
}

// MARK: - 4. A circular icon button (a plain View — small & self-contained)

struct IconButton: View {
    let systemName: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.title3)
                .foregroundStyle(.white)
                .frame(width: 44, height: 44)      // 44pt = min tap target
                .background(Theme.accent, in: Circle())
        }
    }
}

// MARK: - 5. Loading button (a wrapper View — it owns the spinner state)
//
// Use a View (not a ButtonStyle) when the button needs its own layout/state.

struct LoadingButton: View {
    let title: String
    @Binding var isLoading: Bool
    var action: () async -> Void

    init(_ title: String, isLoading: Binding<Bool>, action: @escaping () async -> Void) {
        self.title = title
        self._isLoading = isLoading
        self.action = action
    }

    var body: some View {
        Button {
            Task {
                isLoading = true
                await action()
                isLoading = false
            }
        } label: {
            ZStack {
                // Keep the title in place (invisible) so the button doesn't resize.
                Text(title).opacity(isLoading ? 0 : 1)
                if isLoading {
                    ProgressView().tint(.white)
                }
            }
        }
        .buttonStyle(PrimaryButtonStyle())
        .disabled(isLoading)          // block double-taps while working
    }
}

// MARK: - Preview / gallery

#Preview {
    struct Demo: View {
        @State private var loading = false
        var body: some View {
            VStack(spacing: Theme.spacing) {
                Button("Primary") {}.buttonStyle(PrimaryButtonStyle())
                Button("Secondary") {}.buttonStyle(SecondaryButtonStyle())
                Button("Delete") {}.buttonStyle(DestructiveButtonStyle())

                HStack { IconButton(systemName: "plus") {}; IconButton(systemName: "heart") {} }

                LoadingButton("Save", isLoading: $loading) {
                    try? await Task.sleep(for: .seconds(1.5))
                }
            }
            .padding()
        }
    }
    return Demo()
}
