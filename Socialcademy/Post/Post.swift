//
//  File.swift
//  Socialcademy
//
//  Created by Roman on 13.10.2022.
//

import Foundation

struct Post: Identifiable, Equatable {
  var title: String
  var content: String
  var author: User
  var isFavorite = false
  var timestamp = Date()
  var id = UUID()

  // enum CodingKeys: CodingKey {
  //     case title, content, author, timestamp, id
  // }

  func contains(_ string: String) -> Bool {
    let properties = [title, content, author.name].map { $0.lowercased() }
      let query = string.lowercased()

      let matches = properties.filter { $0.contains(query) }
      return !matches.isEmpty
  }
}

extension Post {
    static let testPost = Post(
        title: "Lorem ipsum",
        content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
        author: User.testUser
    )
}

extension Post: Codable {
    enum CodingKeys: CodingKey {
        case title, content, author, timestamp, id
    }
}
