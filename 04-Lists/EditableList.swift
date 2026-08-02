//
//  EditableList.swift
//  Swipe-to-delete, reordering, and custom swipe actions.
//

import SwiftUI

struct EditableList: View {
    // Mutable state — editing the array re-renders the list.
    @State private var users = User.sampleList

    var body: some View {
        NavigationStack {
            List {
                ForEach(users) { user in
                    UserRow(user: user)
                        // Custom trailing swipe buttons.
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                delete(user)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                        // Custom leading swipe button.
                        .swipeActions(edge: .leading) {
                            Button {
                                // e.g. mark as favorite
                            } label: {
                                Label("Star", systemImage: "star")
                            }
                            .tint(.yellow)
                        }
                }
                // These two enable the system swipe-to-delete and drag-to-reorder
                // when the list is in edit mode (or, for delete, on swipe).
                .onDelete(perform: deleteAt)
                .onMove(perform: move)
            }
            .navigationTitle("Edit Users")
            .toolbar {
                // Toggles edit mode → shows the reorder handles and delete circles.
                EditButton()
            }
        }
    }

    // MARK: - Mutations

    private func delete(_ user: User) {
        users.removeAll { $0.id == user.id }
    }

    private func deleteAt(_ offsets: IndexSet) {
        users.remove(atOffsets: offsets)
    }

    private func move(from source: IndexSet, to destination: Int) {
        users.move(fromOffsets: source, toOffset: destination)
    }
}

#Preview {
    EditableList()
}
