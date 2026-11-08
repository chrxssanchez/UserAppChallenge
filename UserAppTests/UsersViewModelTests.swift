//
//  Untitled.swift
//  QantasCodeChallenge
//
//  Created by Micah Napier on 12/12/2025.
//

import Foundation
import Testing
@testable import UserApp

@MainActor
struct UsersViewModelTests {
    
    @Test func `loadSuccessShowsUsers`() async throws {
        let users = try JSONDecoder().decode([User].self, from: MockData.usersJSON)
        let viewModel = UsersViewModel(apiClient: MockUsersClient(result: .success(users)))
        
        await viewModel.load()
        
        #expect(viewModel.state == .loaded(users))
    }
    
    @Test func `loadFailureShowsError`() async throws {
        let error = URLError(.notConnectedToInternet)
        let viewModel = UsersViewModel(apiClient: MockUsersClient(result: .failure(error)))
        
        await viewModel.load()
        
        #expect(viewModel.state == .failed(error.localizedDescription))
    }
    
    @Test func `showsLoadingWhileFetching`() async throws {
        let mock = MockUsersClient(result: .success([]))
        let viewModel = UsersViewModel(apiClient: mock)
        var fetchingState: UsersState?
        mock.onFetch = { fetchingState = viewModel.state }
        
        await viewModel.load()
        
        #expect(fetchingState == .loading)
        #expect(viewModel.state == .loaded([]))
    }
    
    @Test func `secondLoadWhileLoadingIsIgnored`() async throws {
        let mock = MockUsersClient(result: .success([]))
        let viewModel = UsersViewModel(apiClient: mock)
        mock.onFetch = {
            await viewModel.load()
        }
        
        await viewModel.load()
        
        #expect(mock.callCount == 1)
    }
}

@MainActor
final class MockUsersClient: UsersFetch {
    var result: Result<[User], Error>
    var onFetch: (() async -> Void)?
    private(set) var callCount = 0
    
    init(result: Result<[User], Error>){
        self.result = result
    }
    
    func fetchUsers() async throws -> [User] {
        callCount += 1
        await onFetch?()
        return try result.get()
    }
}
