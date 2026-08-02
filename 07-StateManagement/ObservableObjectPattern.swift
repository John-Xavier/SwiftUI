//
//  ObservableObjectPattern.swift
//  @StateObject (owner) vs @ObservedObject (receiver).
//

import SwiftUI

// A classic (pre-iOS 17) view model.
@MainActor
final class CartViewModel: ObservableObject {
    // @Published broadcasts changes to observing views, triggering re-render.
    @Published var items: [String] = []

    var total: Int { items.count }

    func add(_ item: String) { items.append(item) }
}

// MARK: - Owner uses @StateObject
//
// This view CREATES the view model, so it must use @StateObject.
// @StateObject creates the object exactly once and keeps it alive across
// re-renders. (Using @ObservedObject here would recreate it every render → bug.)

struct CartScreen: View {
    @StateObject private var viewModel = CartViewModel()

    var body: some View {
        VStack {
            Text("Items in cart: \(viewModel.total)")

            Button("Add item") { viewModel.add("🍎") }

            // Pass the SAME instance down to a child.
            CartSummary(viewModel: viewModel)
        }
    }
}

// MARK: - Receiver uses @ObservedObject
//
// This view RECEIVES the view model from its parent — it does not own it.
// Use @ObservedObject for passed-in ObservableObjects.

struct CartSummary: View {
    @ObservedObject var viewModel: CartViewModel

    var body: some View {
        List(viewModel.items, id: \.self) { Text($0) }
    }
}

#Preview {
    CartScreen()
}
