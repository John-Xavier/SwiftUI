//
//  StateAndBinding.swift
//  @State in a parent, @Binding in a child.
//

import SwiftUI

// MARK: - Parent owns the state with @State

struct CounterParent: View {
    // @State: this view OWNS this value. SwiftUI stores it across re-renders.
    // Marked private because state should never be set from outside.
    @State private var count = 0
    @State private var isOn = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Count: \(count)")

            // Pass a two-way BINDING with the `$` prefix.
            // The child can now read AND write our `count`.
            StepperControl(value: $count)

            // A binding to a Bool drives a Toggle.
            Toggle("Enabled", isOn: $isOn)
        }
        .padding()
    }
}

// MARK: - Child borrows the state with @Binding

struct StepperControl: View {
    // @Binding: this view does NOT own the value — it reads/writes the parent's.
    @Binding var value: Int

    var body: some View {
        HStack {
            Button("–") { value -= 1 }      // mutating the binding updates the parent
            Text("\(value)").monospacedDigit()
            Button("+") { value += 1 }
        }
        .buttonStyle(.bordered)
    }
}

// MARK: - Previews can supply a binding with .constant(...)

#Preview("Parent") {
    CounterParent()
}

#Preview("Child only") {
    // `.constant` makes a read-only binding — handy for previewing child views.
    StepperControl(value: .constant(5))
}
