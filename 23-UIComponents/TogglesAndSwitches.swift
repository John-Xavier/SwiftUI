//
//  TogglesAndSwitches.swift
//  Native switch (simple), tinted switch, checkbox toggle, and a custom switch.
//

import SwiftUI

// MARK: - 1. Native toggle / switch (the default)

struct NativeToggles: View {
    @State private var isOn = true

    var body: some View {
        VStack {
            Toggle("Notifications", isOn: $isOn)

            // Change the ON color with .tint.
            Toggle("Dark mode", isOn: $isOn)
                .tint(.purple)

            // Label-less switch (e.g. inside a custom row).
            Toggle("", isOn: $isOn).labelsHidden()
        }
        .padding()
    }
}

// MARK: - 2. Checkbox-style toggle (custom ToggleStyle)
//
// A ToggleStyle lets you completely restyle a Toggle while keeping its behavior.

struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button {
            configuration.isOn.toggle()
        } label: {
            HStack {
                Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                    .foregroundStyle(configuration.isOn ? .blue : .secondary)
                    .font(.title3)
                configuration.label
            }
        }
        .buttonStyle(.plain)
    }
}

// MARK: - 3. Fully custom switch (draw it yourself)

struct CustomSwitch: View {
    @Binding var isOn: Bool

    var body: some View {
        // Track
        RoundedRectangle(cornerRadius: 16)
            .fill(isOn ? Color.green : Color(.systemGray4))
            .frame(width: 52, height: 32)
            .overlay(alignment: isOn ? .trailing : .leading) {
                // Knob
                Circle()
                    .fill(.white)
                    .padding(3)
                    .shadow(radius: 1)
            }
            .animation(.spring(duration: 0.25), value: isOn)
            .onTapGesture { isOn.toggle() }
    }
}

// MARK: - Preview

#Preview {
    struct Demo: View {
        @State private var a = true
        @State private var agree = false
        @State private var custom = true
        var body: some View {
            VStack(alignment: .leading, spacing: 24) {
                NativeToggles()
                Toggle("I agree to the terms", isOn: $agree)
                    .toggleStyle(CheckboxToggleStyle())
                    .padding(.horizontal)
                HStack { Text("Custom switch"); Spacer(); CustomSwitch(isOn: $custom) }
                    .padding(.horizontal)
            }
        }
    }
    return Demo()
}
