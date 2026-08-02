//
//  CombineNetworking.swift
//  URLSession.dataTaskPublisher → decode → drive the UI.
//
//  Shown for completeness / legacy codebases. For new code prefer the
//  async/await client in ../02-Networking.
//

import SwiftUI
import Combine

@MainActor
final class CombineUsersViewModel: ObservableObject {
    @Published private(set) var users: [User] = []
    @Published private(set) var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()

    func load() {
        let url = URL(string: "https://reqres.in/api/users")!

        URLSession.shared
            // A publisher that emits (data, response) once, then finishes.
            .dataTaskPublisher(for: url)
            // Validate the status code and pull out Data.
            .tryMap { data, response in
                guard let http = response as? HTTPURLResponse,
                      200..<300 ~= http.statusCode else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            // Decode JSON into our model. `decode` is a built-in Combine operator.
            .decode(type: PagedResponse<User>.self, decoder: {
                let d = JSONDecoder()
                d.keyDecodingStrategy = .convertFromSnakeCase
                return d
            }())
            .map(\.data)                              // keep just the users array
            .receive(on: DispatchQueue.main)          // UI updates on main
            // sink handles BOTH completion (success/failure) and each value.
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] users in
                    self?.users = users
                }
            )
            .store(in: &cancellables)
    }
}

struct CombineUsersView: View {
    @StateObject private var viewModel = CombineUsersViewModel()

    var body: some View {
        List(viewModel.users) { Text($0.fullName) }
            .overlay { if let msg = viewModel.errorMessage { Text(msg) } }
            .onAppear { viewModel.load() }
    }
}
