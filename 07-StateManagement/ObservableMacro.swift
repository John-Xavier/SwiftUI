//
//  ObservableMacro.swift
//  iOS 17+ @Observable — the modern replacement for ObservableObject.
//

import SwiftUI
import Observation   // provides the @Observable macro

// MARK: - Define the model with @Observable
//
// No `@Published` needed — every stored property is observed automatically.
// SwiftUI re-renders ONLY the views that read a property that actually changed,
// which is more efficient than ObservableObject's all-or-nothing @Published.

@Observable
final class TodoStore {
    var todos: [String] = []
    var filter: String = ""

    // Not observed for storage, but reading it in a view still tracks `todos`/`filter`.
    var visibleTodos: [String] {
        filter.isEmpty ? todos : todos.filter { $0.localizedCaseInsensitiveContains(filter) }
    }

    func add(_ todo: String) { todos.append(todo) }
}

// MARK: - Owning view uses plain @State (not @StateObject)

struct TodoScreen: View {
    // With @Observable, the OWNER uses @State (yes, @State — not @StateObject).
    @State private var store = TodoStore()

    var body: some View {
        NavigationStack {
            List {
                ForEach(store.visibleTodos, id: \.self) { Text($0) }
            }
            .searchable(text: $store.filter)   // bindings work directly on properties
            .navigationTitle("Todos")
            .toolbar {
                Button("Add") { store.add("Task \(store.todos.count + 1)") }
            }
        }
    }
}

// MARK: - Passing it to a child
//
// Just pass it as a normal property — the child re-renders on relevant changes.
// No @ObservedObject wrapper needed.

struct TodoCountBadge: View {
    let store: TodoStore   // plain property; observation still works

    var body: some View {
        Text("\(store.todos.count)")
    }
}

// MARK: - Injecting through the environment (iOS 17 style)
//
//   RootView().environment(store)          // inject
//   @Environment(TodoStore.self) var store // read

#Preview {
    TodoScreen()
}
