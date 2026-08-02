//
//  FormValidation.swift
//  Live validation, focus management, and a disabled submit button.
//

import SwiftUI

struct SignUpForm: View {
    @State private var email = ""
    @State private var password = ""

    // @FocusState tracks which field is active so we can move focus / dismiss keyboard.
    @FocusState private var focusedField: Field?
    enum Field { case email, password }

    // MARK: - Derived validation (recomputed on every keystroke)

    private var isEmailValid: Bool {
        email.contains("@") && email.contains(".")
    }
    private var isPasswordValid: Bool {
        password.count >= 8
    }
    private var isFormValid: Bool {
        isEmailValid && isPasswordValid
    }

    var body: some View {
        Form {
            Section("Email") {
                TextField("you@example.com", text: $email)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .focused($focusedField, equals: .email)
                    .submitLabel(.next)             // return key says "next"
                    .onSubmit { focusedField = .password }  // jump to next field

                // Inline error only after the user typed something invalid.
                if !email.isEmpty && !isEmailValid {
                    Text("Enter a valid email").font(.caption).foregroundStyle(.red)
                }
            }

            Section("Password") {
                SecureField("At least 8 characters", text: $password)
                    .focused($focusedField, equals: .password)
                    .submitLabel(.done)
                    .onSubmit { submit() }

                if !password.isEmpty && !isPasswordValid {
                    Text("Too short").font(.caption).foregroundStyle(.red)
                }
            }

            Section {
                Button("Sign Up", action: submit)
                    // Disable until everything is valid — the cleanest UX.
                    .disabled(!isFormValid)
            }
        }
    }

    private func submit() {
        guard isFormValid else { return }
        focusedField = nil    // dismiss the keyboard
        // …perform sign-up…
    }
}

#Preview {
    SignUpForm()
}
