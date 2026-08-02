//
//  InitializerInjection.swift
//  The simplest, most testable DI: pass dependencies into init.
//

import SwiftUI

// A view model depends on a PROTOCOL, not a concrete service.
// This is the key to testability: any type conforming to the protocol works.
@MainActor
final class ProfileViewModel: ObservableObject {
    @Published var user: User?

    private let service: UserServiceProtocol   // <- injected abstraction

    init(service: UserServiceProtocol) {       // <- injection point
        self.service = service
    }

    func load(id: Int) async {
        user = try? await service.fetchUser(id: id)
    }
}

struct ProfileView: View {
    @StateObject private var viewModel: ProfileViewModel
    let userID: Int

    // The view forwards the injected service to the view model.
    init(userID: Int, service: UserServiceProtocol) {
        self.userID = userID
        _viewModel = StateObject(wrappedValue: ProfileViewModel(service: service))
    }

    var body: some View {
        Group {
            if let user = viewModel.user {
                Text(user.fullName)
            } else {
                ProgressView()
            }
        }
        .task { await viewModel.load(id: userID) }
    }
}

// MARK: - Composition root
//
// Assemble real dependencies in ONE place (often your App struct),
// then hand them down. This is the "composition root" pattern.

enum AppDependencies {
    static let apiClient: APIClientProtocol = APIClient(
        baseURL: URL(string: "https://reqres.in/api")!
    )
    static let userService: UserServiceProtocol = UserService(client: apiClient)
}

// MARK: - Previews use a mock, no network needed

#Preview {
    ProfileView(userID: 1, service: MockUserService())
}
