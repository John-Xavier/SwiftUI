//
//  SheetsAndCovers.swift
//  .sheet, .fullScreenCover, item-based sheets, and detents.
//

import SwiftUI

struct SheetsAndCovers: View {
    @State private var showSettings = false
    @State private var showOnboarding = false
    @State private var selectedUser: User?   // item-based: nil = hidden

    var body: some View {
        List {
            // MARK: 1. Boolean-triggered sheet with detents
            Button("Show settings sheet") { showSettings = true }
                .sheet(isPresented: $showSettings) {
                    SheetContent(title: "Settings")
                        // Half-height and full-height stops; user can drag between them.
                        .presentationDetents([.medium, .large])
                        .presentationDragIndicator(.visible)
                }

            // MARK: 2. Item-based sheet (passes the selected model in)
            // Preferred when the sheet is "for" a specific object — no stale-data bug.
            ForEach(User.sampleList) { user in
                Button(user.fullName) { selectedUser = user }
            }
            .sheet(item: $selectedUser) { user in
                SheetContent(title: user.fullName)
                    .presentationDetents([.medium])
            }

            // MARK: 3. Full-screen cover (e.g. onboarding/login)
            Button("Show full-screen cover") { showOnboarding = true }
                .fullScreenCover(isPresented: $showOnboarding) {
                    OnboardingCover()
                }
        }
    }
}

// A reusable sheet body that can dismiss itself.
struct SheetContent: View {
    let title: String
    // `dismiss` is the modern way to close a sheet/cover from inside it.
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Text("Content for \(title)")
                .navigationTitle(title)
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Done") { dismiss() }
                    }
                }
        }
    }
}

struct OnboardingCover: View {
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        VStack(spacing: 20) {
            Text("Welcome!").font(.largeTitle.bold())
            Button("Get Started") { dismiss() }
                .buttonStyle(.borderedProminent)
        }
    }
}

#Preview {
    SheetsAndCovers()
}
