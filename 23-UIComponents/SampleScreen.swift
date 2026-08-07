//
//  SampleScreen.swift
//  A full screen that assembles the components in this folder into one UI.
//
//  It reuses: Avatar, StatusBadge, StarRatingView, Pill, Card,
//  CustomSegmentedControl, Toggle, SearchBar, PrimaryButtonStyle, and a toast.
//  This shows how the small pieces compose into a real screen.
//

import SwiftUI

struct SampleProfileScreen: View {
    @State private var section = 0                 // custom segmented control
    @State private var notificationsOn = true
    @State private var publicProfile = false
    @State private var query = ""
    @State private var toast: String?
    @State private var showActions = false

    private let skills = ["SwiftUI", "Combine", "Async", "Core Data", "Charts"]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    header
                    segmented

                    // Switch content based on the selected segment.
                    if section == 0 { aboutSection } else { settingsSection }

                    saveButton
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Profile")
            .toolbar {
                Button {
                    showActions = true
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
            // Reuses the toast + bottom sheet components from this folder.
            .toast($toast, style: .success)
            .sheet(isPresented: $showActions) {
                actionSheet
                    .presentationDetents([.fraction(0.3)])
                    .presentationDragIndicator(.visible)
            }
        }
    }

    // MARK: Header card (Avatar + status + rating + tags)

    private var header: some View {
        Card {
            VStack(spacing: 12) {
                AvatarWithStatus(name: "John Xavier", isOnline: true, size: 72)

                VStack(spacing: 4) {
                    Text("John Xavier").font(.title2.bold())
                    StatusBadge(status: .online)
                }

                StarRatingView(rating: 4.5, size: 18)

                // Skill pills wrap onto multiple lines.
                FlowLayout {
                    ForEach(skills, id: \.self) { Pill(text: $0) }
                }
            }
            .frame(maxWidth: .infinity)
        }
    }

    // MARK: Segmented control

    private var segmented: some View {
        CustomSegmentedControl(options: ["About", "Settings"], selection: $section)
    }

    // MARK: About tab

    private var aboutSection: some View {
        Card {
            VStack(alignment: .leading, spacing: 12) {
                Text("About").font(.headline)
                Text("iOS developer who loves building clean, reusable SwiftUI components.")
                    .foregroundStyle(.secondary)

                Divider()

                // Search bar reused here to filter skills.
                SearchBar(text: $query, placeholder: "Search skills")
                ForEach(skills.filter { query.isEmpty || $0.localizedCaseInsensitiveContains(query) }, id: \.self) {
                    Text("• \($0)")
                }
            }
        }
    }

    // MARK: Settings tab

    private var settingsSection: some View {
        Card {
            VStack(spacing: 4) {
                Toggle("Notifications", isOn: $notificationsOn)
                Divider()
                Toggle("Public profile", isOn: $publicProfile)
            }
        }
    }

    // MARK: Save button (shows a toast)

    private var saveButton: some View {
        Button("Save changes") {
            toast = "Profile saved!"
        }
        .buttonStyle(PrimaryButtonStyle())
    }

    // MARK: Bottom-sheet actions

    private var actionSheet: some View {
        VStack(spacing: 16) {
            Text("Actions").font(.headline).padding(.top)
            Button("Share profile") { showActions = false }
            Button("Report", role: .destructive) { showActions = false }
            Spacer()
        }
        .padding()
    }
}

#Preview {
    SampleProfileScreen()
}
