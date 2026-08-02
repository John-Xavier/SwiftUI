//
//  AlertsAndDialogs.swift
//  .alert (with roles and a text field) and .confirmationDialog.
//

import SwiftUI

struct AlertsAndDialogs: View {
    @State private var showDeleteAlert = false
    @State private var showRenameAlert = false
    @State private var showActionSheet = false
    @State private var name = ""

    var body: some View {
        List {
            // MARK: Basic destructive alert
            Button("Delete…") { showDeleteAlert = true }
                .alert("Delete item?", isPresented: $showDeleteAlert) {
                    // `role: .destructive` renders red; `.cancel` is bold + dismisses.
                    Button("Delete", role: .destructive) { /* delete */ }
                    Button("Cancel", role: .cancel) {}
                } message: {
                    Text("This action cannot be undone.")
                }

            // MARK: Alert with a text field (iOS 16+)
            Button("Rename…") { showRenameAlert = true }
                .alert("Rename", isPresented: $showRenameAlert) {
                    TextField("New name", text: $name)
                    Button("Save") { /* use name */ }
                    Button("Cancel", role: .cancel) {}
                }

            // MARK: Confirmation dialog (action sheet)
            Button("More actions…") { showActionSheet = true }
                .confirmationDialog("Choose an action", isPresented: $showActionSheet, titleVisibility: .visible) {
                    Button("Duplicate") {}
                    Button("Archive") {}
                    Button("Delete", role: .destructive) {}
                    // A .cancel button is added automatically on iOS, but you can add one.
                }
        }
    }
}

#Preview {
    AlertsAndDialogs()
}
