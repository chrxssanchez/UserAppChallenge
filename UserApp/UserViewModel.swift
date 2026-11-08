// UsersViewModel.swift

import Foundation
import Observation

enum UsersState: Equatable {
    case idle
    case loading
    case loaded([User])
    case failed(String)
}

@MainActor
@Observable
final class UsersViewModel {
    private(set) var state: UsersState = .idle

    private let apiClient: UsersFetch

    init(apiClient: UsersFetch) {
        self.apiClient = apiClient
    }
    
    var isLoading: Bool {
        state == .loading
    }

    func load() async {
        guard !isLoading else { return }
        state = .loading

        do {
            let users = try await apiClient.fetchUsers()
            state = .loaded(users)
        } catch {
            state = .failed(error.localizedDescription)
        }
    }
}
