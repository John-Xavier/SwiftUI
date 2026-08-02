//
//  ThemeSwitcher.swift
//  A persisted System / Light / Dark picker that drives the whole app.
//

import SwiftUI

// The user's choice. `.system` means "follow the device setting".
enum AppearanceMode: String, CaseIterable, Identifiable {
    case system, light, dark
    var id: Self { self }

    var label: String {
        switch self {
        case .system: "System"
        case .light:  "Light"
        case .dark:   "Dark"
        }
    }

    // Map to SwiftUI's ColorScheme. `.system` → nil = "don't override".
    var colorScheme: ColorScheme? {
        switch self {
        case .system: nil
        case .light:  .light
        case .dark:   .dark
        }
    }
}

// MARK: - Apply the persisted choice at the app root

@main
struct ThemedApp: App {
    // Persisted across launches via UserDefaults.
    @AppStorage("appearanceMode") private var mode: AppearanceMode = .system

    var body: some Scene {
        WindowGroup {
            RootScreen()
                // nil = follow system; otherwise force the chosen scheme app-wide.
                .preferredColorScheme(mode.colorScheme)
        }
    }
}

// MARK: - The picker (e.g. in Settings)

struct RootScreen: View {
    @AppStorage("appearanceMode") private var mode: AppearanceMode = .system

    var body: some View {
        NavigationStack {
            Form {
                Section("Appearance") {
                    Picker("Theme", selection: $mode) {
                        ForEach(AppearanceMode.allCases) { mode in
                            Text(mode.label).tag(mode)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                Section {
                    // These use semantic colors, so they follow the choice automatically.
                    Text("Preview text").foregroundStyle(.primary)
                    Text("Secondary text").foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    RootScreen()
}
