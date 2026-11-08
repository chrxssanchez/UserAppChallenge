// UsersAPIClient.swift

import Foundation

protocol UsersFetch {
    func fetchUsers() async throws -> [User]
}

struct UsersAPIClient: UsersFetch {
    func fetchUsers() async throws -> [User] {
        let url = URL(string: "https://jsonplaceholder.typicode.com/users")!
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let http = response as? HTTPURLResponse,
              (200..<300).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode([User].self, from: data)
    }
}
