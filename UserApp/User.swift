// User.swift

import Foundation

struct Geo: Decodable, Equatable {
    let lat: String
    let lng: String
}

struct Address: Decodable, Equatable {
    let street: String
    let suite: String
    let city: String
    let zipcode: String
    let geo: Geo
}

struct Company: Decodable, Equatable {
    let name: String
    let catchPhrase: String
    let bs: String
}

struct User: Decodable, Identifiable, Equatable {
    let id: Int
    let name: String
    let username: String
    let email: String
    let phone: String
    let website: String
    let address: Address
    let company: Company
}
