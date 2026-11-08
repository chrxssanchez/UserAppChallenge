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
    private let minimumLoadingDuration: Duration

    init(apiClient: UsersFetch, minimumLoadingDuration: Duration = .milliseconds(500)) {
        self.apiClient = apiClient
        self.minimumLoadingDuration = minimumLoadingDuration
    }
    
    var isLoading: Bool {
        state == .loading
    }

    func load() async {
        guard !isLoading else { return }
        state = .loading
        let start = ContinuousClock.now

        do {
            let users = try await apiClient.fetchUsers()
            await waitForMinimumDuration(since: start)
            state = .loaded(users)
        } catch {
            await waitForMinimumDuration(since: start)
            state = .failed(error.localizedDescription)
        }
    }
    
    private func waitForMinimumDuration(since start: ContinuousClock.Instant) async {
        let remaining = minimumLoadingDuration - (ContinuousClock.now - start)
        if remaining > .zero {
            try? await Task.sleep(for: remaining)
        }
    }
}
