//
//  UserAppTests.swift
//  UserAppTests
//
//  Created by Micah Napier on 11/12/2025.
//

import Testing
import Foundation
@testable import UserApp

@MainActor
struct UserDecodingTests {
    
    @Test func decodeUsersFromAPIResponse() throws {
        let users = try JSONDecoder().decode([User].self, from: MockData.usersJSON)
        
        #expect(users.count == 1)
        #expect(users[0].id == 1)
        #expect(users[0].name == "Leanne Graham")
        #expect(users[0].address.street == "Kulas Light")
    }
}

enum MockData {
    static let usersJSON = Data(
        """
            [
                {
                  "id": 1,
                  "name": "Leanne Graham",
                  "username": "Bret",
                  "email": "Sincere@april.biz",
                  "address": {
                    "street": "Kulas Light",
                    "suite": "Apt. 556",
                    "city": "Gwenborough",
                    "zipcode": "92998-3874",
                    "geo": {
                      "lat": "-37.3159",
                      "lng": "81.1496"
                    }
                  },
                  "phone": "1-770-736-8031 x56442",
                  "website": "hildegard.org",
                  "company": {
                    "name": "Romaguera-Crona",
                    "catchPhrase": "Multi-layered client-server neural-net",
                    "bs": "harness real-time e-markets"
                  }
                }
            ]
        """.utf8
    )
}
