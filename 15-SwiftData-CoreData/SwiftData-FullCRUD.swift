//
//  SwiftData-FullCRUD.swift
//  A fuller SwiftData CRUD list (iOS 17+). Read SwiftData-Simple.swift first.
//
//  Requires `import SwiftData` and a deployment target of iOS 17.
//

import SwiftUI
import SwiftData

// MARK: - 1. The model
//
// `@Model` turns a plain class into a persisted database entity.
// Every stored property becomes a column. No CodingKeys, no .xcdatamodeld file.

@Model
final class TaskItem {
    // A unique id is optional — SwiftData tracks identity for you — but handy.
    var title: String
    var isDone: Bool
    var createdAt: Date

    init(title: String, isDone: Bool = false, createdAt: Date = .now) {
        self.title = title
        self.isDone = isDone
        self.createdAt = createdAt
    }
}

// MARK: - 2. App entry point registers the container
//
// `.modelContainer(for:)` creates/opens the on-disk database and injects a
// context into the environment for the whole app.

@main
struct TasksApp: App {
    var body: some Scene {
        WindowGroup {
            TaskListView()
        }
        .modelContainer(for: TaskItem.self)
    }
}

// MARK: - 3. The view: query, insert, update, delete

struct TaskListView: View {
    // The context is the read/write workspace, injected by modelContainer.
    @Environment(\.modelContext) private var context

    // @Query is a LIVE fetch — the list auto-updates when data changes.
    // `sort:` and `filter:` run in the database, not in Swift.
    @Query(sort: \TaskItem.createdAt, order: .reverse) private var tasks: [TaskItem]

    @State private var newTitle = ""

    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack {
                        TextField("New task", text: $newTitle)
                        Button("Add", action: addTask).disabled(newTitle.isBlank)
                    }
                }

                ForEach(tasks) { task in
                    HStack {
                        // Tapping toggles `isDone`. Mutating a @Model property
                        // is saved automatically — no explicit save call needed.
                        Image(systemName: task.isDone ? "checkmark.circle.fill" : "circle")
                            .onTapGesture { task.isDone.toggle() }
                        Text(task.title)
                            .strikethrough(task.isDone)
                    }
                }
                .onDelete(perform: deleteTasks)
            }
            .navigationTitle("Tasks")
        }
    }

    // MARK: CRUD

    private func addTask() {
        context.insert(TaskItem(title: newTitle.trimmed))   // CREATE
        newTitle = ""
        // Optional: try? context.save() — SwiftData autosaves, but you can force it.
    }

    private func deleteTasks(at offsets: IndexSet) {
        for index in offsets {
            context.delete(tasks[index])                    // DELETE
        }
    }
}

// MARK: - 4. Preview with an in-memory container (no disk writes)

#Preview {
    TaskListView()
        .modelContainer(for: TaskItem.self, inMemory: true)
}
