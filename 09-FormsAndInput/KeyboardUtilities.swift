//
//  KeyboardUtilities.swift
//  The keyboard patterns you reach for constantly:
//  a "Done" toolbar button, return-key to dismiss, tap-outside to dismiss,
//  moving between fields, and scrolling so the field isn't hidden.
//

import SwiftUI

// MARK: - 1. "Done" button above the keyboard (dismiss the keyboard)
//
// The number pad has no return key, so users get stuck. Add a Done button to a
// keyboard toolbar. @FocusState is how you programmatically dismiss: set it nil.

struct DoneButtonExample: View {
    @State private var amount = ""
    @FocusState private var isFocused: Bool     // true while the field is editing

    var body: some View {
        Form {
            TextField("Amount", text: $amount)
                .keyboardType(.decimalPad)       // no return key → needs a Done button
                .focused($isFocused)
        }
        .toolbar {
            // `.keyboard` placement pins this bar just above the keyboard.
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()                          // pushes the button to the right
                Button("Done") { isFocused = false }   // nil focus = dismiss keyboard
            }
        }
    }
}

// MARK: - 2. Return / Enter key to dismiss (single field)
//
// For keyboards WITH a return key, `.onSubmit` fires when the user taps it.

struct ReturnToDismissExample: View {
    @State private var name = ""
    @FocusState private var isFocused: Bool

    var body: some View {
        TextField("Name", text: $name)
            .textFieldStyle(.roundedBorder)
            .focused($isFocused)
            .submitLabel(.done)              // makes the return key read "Done"
            .onSubmit { isFocused = false }  // tap return → dismiss
            .padding()
    }
}

// MARK: - 3. Enter to move to the NEXT field, then submit
//
// Chain fields: return advances focus; on the last field it submits.

struct FieldChainExample: View {
    @State private var email = ""
    @State private var password = ""
    @FocusState private var focused: Field?
    enum Field { case email, password }

    var body: some View {
        VStack(spacing: 12) {
            TextField("Email", text: $email)
                .focused($focused, equals: .email)
                .submitLabel(.next)                    // return key says "Next"
                .onSubmit { focused = .password }      // → jump to password

            SecureField("Password", text: $password)
                .focused($focused, equals: .password)
                .submitLabel(.go)                      // return key says "Go"
                .onSubmit { submit() }                 // → submit the form
        }
        .textFieldStyle(.roundedBorder)
        .padding()
    }

    private func submit() {
        focused = nil                                  // dismiss keyboard
        // …log in…
    }
}

// MARK: - 4. Tap anywhere outside to dismiss the keyboard
//
// A reusable modifier: adds a background tap that resigns first responder.

extension View {
    /// Dismiss the keyboard when the user taps outside a text field.
    func dismissKeyboardOnTap() -> some View {
        // `.simultaneousGesture` so it doesn't block buttons inside the view.
        self.simultaneousGesture(
            TapGesture().onEnded { hideKeyboard() }
        )
    }
}

/// Resigns the first responder app-wide (the UIKit way to close the keyboard).
func hideKeyboard() {
    UIApplication.shared.sendAction(
        #selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil
    )
}

struct TapToDismissExample: View {
    @State private var text = ""

    var body: some View {
        VStack {
            TextField("Type, then tap the background", text: $text)
                .textFieldStyle(.roundedBorder)
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .contentShape(Rectangle())        // makes the whole area tappable
        .dismissKeyboardOnTap()
    }
}

// MARK: - 5. Scroll so the focused field isn't hidden by the keyboard
//
// A ScrollView + ScrollViewReader scrolls the active field into view.
// (SwiftUI already avoids the keyboard for most Forms; use this for custom layouts.)

struct ScrollToFieldExample: View {
    @State private var fields = Array(repeating: "", count: 10)
    @FocusState private var focusedIndex: Int?

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                ForEach(0..<fields.count, id: \.self) { i in
                    TextField("Field \(i + 1)", text: $fields[i])
                        .textFieldStyle(.roundedBorder)
                        .focused($focusedIndex, equals: i)
                        .id(i)
                        .padding(.horizontal)
                }
            }
            // When focus changes, scroll that field to the top.
            .onChange(of: focusedIndex) { _, index in
                guard let index else { return }
                withAnimation { proxy.scrollTo(index, anchor: .top) }
            }
        }
    }
}

// MARK: - Previews

#Preview("Done button")  { DoneButtonExample() }
#Preview("Return")       { ReturnToDismissExample() }
#Preview("Field chain")  { FieldChainExample() }
#Preview("Tap dismiss")  { TapToDismissExample() }
#Preview("Scroll")       { ScrollToFieldExample() }
