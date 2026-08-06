//
//  CoreData-Simple.swift
//  The smallest working Core Data setup, in plain code.
//
//  Core Data has a reputation for being confusing. Strip it down and it's just
//  three things:
//    • Container = the database file.
//    • Context   = your scratchpad where you add/edit/delete.
//    • save()    = write the scratchpad back to the file.
//
//  ONE manual step you can't skip: create a Data Model file in Xcode
//  (File → New → File → Data Model), add an Entity called "Note" with a
//  String attribute "text". Name the model file "Model.xcdatamodeld".
//  See CoreData-StepByStep.md for screenshots-in-words of that step.
//

import SwiftUI
import CoreData

// MARK: - 1. The database (copy this once, change the name to match your model)

final class CoreDataStack {
    static let shared = CoreDataStack()

    let container: NSPersistentContainer

    init() {
        // "Model" MUST match your .xcdatamodeld filename.
        container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores { _, error in
            if let error { fatalError("Core Data error: \(error)") }
        }
    }

    // The context is where you read and write.
    var context: NSManagedObjectContext { container.viewContext }

    // Core Data does NOT autosave — call this after changes.
    func save() {
        guard context.hasChanges else { return }
        try? context.save()
    }
}

// MARK: - 2. Give the whole app the context
//
//   @main
//   struct MyApp: App {
//       var body: some Scene {
//           WindowGroup { NotesScreen() }
//               .environment(\.managedObjectContext, CoreDataStack.shared.context)
//       }
//   }

// MARK: - 3. Read + write in a view

struct NotesScreen: View {
    @Environment(\.managedObjectContext) private var context

    // @FetchRequest reads all Notes and keeps the list live.
    // (Note: Core Data auto-generates the `Note` class from your model file.)
    @FetchRequest(sortDescriptors: []) private var notes: FetchedResults<Note>

    var body: some View {
        List {
            Button("Add note") {
                let note = Note(context: context)   // CREATE
                note.text = "New note"
                CoreDataStack.shared.save()          // ← remember to save!
            }

            ForEach(notes) { note in
                Text(note.text ?? "")                // attributes are Optional in Core Data
            }
            .onDelete { indexes in
                for i in indexes { context.delete(notes[i]) }   // DELETE
                CoreDataStack.shared.save()
            }
        }
    }
}

// To EDIT: change a property then call save():  note.text = "Updated"; stack.save()

// NOTE: This file won't compile until the `Note` entity exists in your
// Model.xcdatamodeld (that's what generates the `Note` class). It's here to show
// the SHAPE of the code. On iOS 17+, SwiftData (see SwiftData-Simple.swift) needs
// no model file and is much simpler — prefer it for new apps.
