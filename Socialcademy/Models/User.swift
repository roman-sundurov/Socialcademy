//
//  User.swift
//  Socialcademy
//
//  Created by Roman on 18.12.2022.
//

import Foundation

struct User: Identifiable, Equatable, Codable {
    var id: String
    var name: String
}

extension User {
    static let testUser = User(id: "", name: "Jamie Harris")
}
