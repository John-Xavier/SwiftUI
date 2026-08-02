//
//  DebouncedSearch.swift
//  Debounce keystrokes before hitting the network.
//
//  Without debouncing, typing "john" fires 4 network requests (j, jo, joh, john).
//  Debouncing waits until the user pauses (e.g. 300ms) before searching.
//

import SwiftUI

@MainActor
final class DebouncedSearchViewModel: ObservableObject {
    @Published var query = ""
    @Published private(set) var results: [User] = []
    @Published private(set) var isSearching = false

    private let service: UserServiceProtocol
    private var searchTask: Task<Void, Never>?   // holds the in-flight debounce/search

    init(service: UserServiceProtocol) {
        self.service = service
    }

    /// Call this from the view whenever `query` changes.
    /// It cancels any pending search and starts a fresh debounced one.
    func search(for text: String) {
        // Cancel the previous task — this is the "debounce": if the user keeps
        // typing, the old pending search never runs.
        searchTask?.cancel()

        guard !text.isEmpty else {
            results = []
            return
        }

        searchTask = Task {
            // Wait 300ms. If cancelled during the sleep, we bail out below.
            try? await Task.sleep(for: .milliseconds(300))
            guard !Task.isCancelled else { return }

            isSearching = true
            defer { isSearching = false }

            // In a real app this would be a search endpoint; here we filter mock data.
            let all = (try? await service.fetchUsers(page: 1)) ?? []
            guard !Task.isCancelled else { return }

            results = all.filter {
                $0.fullName.localizedCaseInsensitiveContains(text)
            }
        }
    }
}

struct DebouncedSearchView: View {
    @StateObject private var viewModel: DebouncedSearchViewModel

    init(service: UserServiceProtocol) {
        _viewModel = StateObject(wrappedValue: DebouncedSearchViewModel(service: service))
    }

    var body: some View {
        NavigationStack {
            List(viewModel.results) { Text($0.fullName) }
                .overlay {
                    if viewModel.isSearching { ProgressView() }
                }
                .navigationTitle("Search")
                .searchable(text: $viewModel.query, prompt: "Search users")
                // iOS 17+: react to changes with the two-parameter closure.
                .onChange(of: viewModel.query) { _, newValue in
                    viewModel.search(for: newValue)
                }
        }
    }
}

#Preview {
    DebouncedSearchView(service: MockUserService())
}
