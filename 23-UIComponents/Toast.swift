//
//  Toast.swift
//  A toast / snackbar overlay with auto-dismiss.
//
//  A toast is a small, temporary message that slides in, then disappears.
//  We expose it as a `.toast(...)` view modifier so any screen can use it.
//

import SwiftUI

// MARK: - 1. The toast's look

struct ToastView: View {
    enum Style { case success, error, info
        var icon: String { switch self { case .success: "checkmark.circle.fill"; case .error: "xmark.octagon.fill"; case .info: "info.circle.fill" } }
        var color: Color { switch self { case .success: .green; case .error: .red; case .info: .blue } }
    }
    let message: String
    var style: Style = .info

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: style.icon).foregroundStyle(style.color)
            Text(message).font(.subheadline).foregroundStyle(.primary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(.regularMaterial, in: Capsule())     // frosted background
        .shadow(color: .black.opacity(0.15), radius: 8, y: 4)
        .padding(.horizontal)
    }
}

// MARK: - 2. A view modifier so callers write `.toast($message)`

struct ToastModifier: ViewModifier {
    @Binding var message: String?           // nil = hidden; set a string to show
    var style: ToastView.Style = .info
    var duration: TimeInterval = 2.5

    func body(content: Content) -> some View {
        content.overlay(alignment: .bottom) {
            if let message {
                ToastView(message: message, style: style)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    // Auto-dismiss after `duration`.
                    .task {
                        try? await Task.sleep(for: .seconds(duration))
                        withAnimation { self.message = nil }
                    }
            }
        }
        .animation(.spring(duration: 0.35), value: message)
    }
}

extension View {
    /// Show a toast whenever `message` is non-nil.
    ///
    ///   @State private var toast: String?
    ///   SomeView().toast($toast, style: .success)
    ///   // trigger it:  toast = "Saved!"
    func toast(_ message: Binding<String?>, style: ToastView.Style = .info) -> some View {
        modifier(ToastModifier(message: message, style: style))
    }
}

// MARK: - Preview

#Preview {
    struct Demo: View {
        @State private var toast: String?
        var body: some View {
            VStack {
                Button("Show success toast") { toast = "Saved successfully!" }
                    .buttonStyle(.borderedProminent)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .toast($toast, style: .success)
        }
    }
    return Demo()
}
