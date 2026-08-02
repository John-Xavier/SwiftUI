//
//  DebouncedSearchCombine.swift
//  The classic debounced search — Combine style (compare with 05-Search async version).
//

import SwiftUI
import Combine

@MainActor
final class CombineSearchViewModel: ObservableObject {
    @Published var query = ""                 // bound to the search field
    @Published private(set) var results: [User] = []

    private let service: UserServiceProtocol
    private var cancellables = Set<AnyCancellable>()

    init(service: UserServiceProtocol) {
        self.service = service

        // This is where Combine really pays off: the whole debounce pipeline is
        // declarative and reads top-to-bottom.
        $query
            // Wait until the user pauses typing for 300ms.
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            // Ignore repeats (e.g. type then delete back to the same text).
            .removeDuplicates()
            // Turn each query into a search publisher, cancelling the previous one.
            .map { [service] text -> AnyPublisher<[User], Never> in
                guard !text.isEmpty else {
                    return Just([]).eraseToAnyPublisher()
                }
                // Wrap the async service call in a Future publisher.
                return Future { promise in
                    Task {
                        let all = (try? await service.fetchUsers(page: 1)) ?? []
                        promise(.success(all.filter {
                            $0.fullName.localizedCaseInsensitiveContains(text)
                        }))
                    }
                }
                .eraseToAnyPublisher()
            }
            // switchToLatest cancels the in-flight search when a newer one arrives.
            .switchToLatest()
            .receive(on: DispatchQueue.main)
            .assign(to: &$results)
    }
}

struct CombineSearchView: View {
    @StateObject private var viewModel: CombineSearchViewModel

    init(service: UserServiceProtocol) {
        _viewModel = StateObject(wrappedValue: CombineSearchViewModel(service: service))
    }

    var body: some View {
        NavigationStack {
            List(viewModel.results) { Text($0.fullName) }
                .navigationTitle("Search")
                .searchable(text: $viewModel.query)
        }
    }
}

#Preview {
    CombineSearchView(service: MockUserService())
}
