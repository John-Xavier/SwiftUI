//
//  SearchBar.swift
//  A custom, reusable search bar view.
//
//  NOTE: For list screens, prefer the built-in `.searchable` modifier
//  (see ../05-Search). Use THIS custom bar when you need a search field
//  somewhere `.searchable` can't go (a custom header, a sheet, mid-screen).
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    var placeholder: String = "Search"

    // Tracks focus so we can show a "Cancel" button while editing.
    @FocusState private var isFocused: Bool

    var body: some View {
        HStack(spacing: 8) {
            HStack(spacing: 6) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)

                TextField(placeholder, text: $text)
                    .focused($isFocused)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .submitLabel(.search)

                // Clear button appears only when there's text.
                if !text.isEmpty {
                    Button {
                        text = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding(8)
            .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 10))

            // Cancel button slides in while editing.
            if isFocused {
                Button("Cancel") {
                    text = ""
                    isFocused = false
                }
                .transition(.move(edge: .trailing).combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.2), value: isFocused)
    }
}

// MARK: - Preview: search bar filtering a list

#Preview {
    struct Demo: View {
        @State private var query = ""
        let items = ["Apple", "Banana", "Cherry", "Date", "Elderberry"]
        var filtered: [String] {
            query.isEmpty ? items : items.filter { $0.localizedCaseInsensitiveContains(query) }
        }
        var body: some View {
            VStack {
                SearchBar(text: $query, placeholder: "Search fruit")
                    .padding(.horizontal)
                List(filtered, id: \.self) { Text($0) }
            }
        }
    }
    return Demo()
}
