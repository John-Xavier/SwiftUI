//
//  AppStorageExample.swift
//  @AppStorage — the easiest way to persist small settings.
//

import SwiftUI

struct SettingsView: View {
    // @AppStorage reads/writes UserDefaults AND updates the UI when it changes.
    // The string is the UserDefaults key. The value after `=` is the default.
    @AppStorage("isDarkMode")   private var isDarkMode = false
    @AppStorage("username")     private var username = ""
    @AppStorage("launchCount")  private var launchCount = 0

    var body: some View {
        Form {
            Section("Appearance") {
                // Editing the toggle persists to UserDefaults instantly — no save button.
                Toggle("Dark mode", isOn: $isDarkMode)
            }

            Section("Profile") {
                TextField("Username", text: $username)
            }

            Section {
                Text("Times launched: \(launchCount)")
                Button("Increment") { launchCount += 1 }
            }
        }
        // Apply the persisted preference to the whole view.
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
}

// Enums persist too — back them by a RawRepresentable the wrapper understands.
enum Theme: String { case system, light, dark }

struct ThemePickerExample: View {
    @AppStorage("theme") private var theme: Theme = .system

    var body: some View {
        Picker("Theme", selection: $theme) {
            Text("System").tag(Theme.system)
            Text("Light").tag(Theme.light)
            Text("Dark").tag(Theme.dark)
        }
        .pickerStyle(.segmented)
    }
}

#Preview("Settings") { SettingsView() }
#Preview("Theme")    { ThemePickerExample().padding() }
