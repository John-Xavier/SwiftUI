//
//  SwiftData-Simple.swift
//  START HERE — the smallest possible SwiftData app (iOS 17+).
//
//  SwiftData saves your objects to a database with almost no code. Three steps:
//    1. Mark your class @Model.
//    2. Add .modelContainer(for:) once, at the app root.
//    3. In a view, use @Query to read and modelContext to add/delete.
//

import SwiftUI
import SwiftData

// MARK: - Step 1: the model
// @Model = "save objects of this class to the database". That's it.

@Model
final class Note {
    var text: String
    init(text: String) { self.text = text }
}

// MARK: - Step 2: turn on the database (do this ONCE, at the app root)
//
//   @main
//   struct MyApp: App {
//       var body: some Scene {
//           WindowGroup { NotesView() }
//               .modelContainer(for: Note.self)   // ← creates/opens the database
//       }
//   }

// MARK: - Step 3: read + write in a view

struct NotesView: View {
    // `context` is how you add and delete. It's provided by modelContainer.
    @Environment(\.modelContext) private var context

    // @Query reads ALL notes and keeps the list live — add one and it appears.
    @Query private var notes: [Note]

    var body: some View {
        List {
            // Add button
            Button("Add note") {
                context.insert(Note(text: "New note"))   // CREATE (saved automatically)
            }

            // Show every note
            ForEach(notes) { note in
                Text(note.text)
            }
            .onDelete { indexes in
                for i in indexes { context.delete(notes[i]) }   // DELETE
            }
        }
    }
}

// To EDIT: just change a property — `note.text = "Updated"` — SwiftData saves it.

#Preview {
    NotesView()
        .modelContainer(for: Note.self, inMemory: true)   // fake in-memory DB for previews
}
