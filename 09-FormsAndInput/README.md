# Forms & Input

`Form` gives you a native, grouped settings-style layout. Controls bind to state with `$`.

## Files

- [`FormExample.swift`](./FormExample.swift) — `TextField`, `SecureField`, `Toggle`, `Picker`, `Stepper`, `DatePicker`, `Slider`.
- [`FormValidation.swift`](./FormValidation.swift) — live validation, disabled submit, focus management.

## Common controls

| Control | Binds to |
|---------|----------|
| `TextField("Name", text: $name)` | `String` |
| `SecureField` | `String` (password) |
| `Toggle("On", isOn: $flag)` | `Bool` |
| `Picker("Role", selection: $role)` | any `Hashable` |
| `Stepper("Qty", value: $qty, in: 0...10)` | `Int` |
| `Slider(value: $amount, in: 0...1)` | `Double` |
| `DatePicker("Date", selection: $date)` | `Date` |

## Keyboard & focus

- `.keyboardType(.emailAddress)` / `.numberPad` etc.
- `.textInputAutocapitalization(.never)` for emails/usernames.
- `@FocusState` to move between fields and dismiss the keyboard.
- `.submitLabel(.next)` to control the return key.

## Validation pattern

Compute validity from state and drive the submit button's `.disabled(...)`:

```swift
private var isValid: Bool {
    !email.isEmpty && email.contains("@") && password.count >= 8
}
Button("Sign Up") { ... }.disabled(!isValid)
```
