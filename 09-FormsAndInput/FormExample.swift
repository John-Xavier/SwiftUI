//
//  FormExample.swift
//  Every common Form control, each bound to @State.
//

import SwiftUI

struct FormExample: View {
    @State private var name = ""
    @State private var password = ""
    @State private var notificationsOn = true
    @State private var role: Role = .member
    @State private var quantity = 1
    @State private var volume = 0.5
    @State private var birthday = Date.now

    enum Role: String, CaseIterable, Identifiable {
        case admin, member, guest
        var id: Self { self }
    }

    var body: some View {
        Form {
            Section("Account") {
                // Text input. keyboardType + autocapitalization tune the keyboard.
                TextField("Full name", text: $name)
                    .textInputAutocapitalization(.words)

                // Masked input for passwords.
                SecureField("Password", text: $password)
            }

            Section("Preferences") {
                Toggle("Notifications", isOn: $notificationsOn)

                // Picker with an enum. `.pickerStyle` changes the presentation.
                Picker("Role", selection: $role) {
                    ForEach(Role.allCases) { role in
                        Text(role.rawValue.capitalized).tag(role)
                    }
                }

                Stepper("Quantity: \(quantity)", value: $quantity, in: 1...10)

                // Slider produces a Double between the bounds.
                HStack {
                    Text("Volume")
                    Slider(value: $volume, in: 0...1)
                }

                DatePicker("Birthday", selection: $birthday, displayedComponents: .date)
            }

            Section {
                Button("Save") { /* submit */ }
            }
        }
    }
}

#Preview {
    FormExample()
}
