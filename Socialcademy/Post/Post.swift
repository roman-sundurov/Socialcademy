//
//  File.swift
//  Socialcademy
//
//  Created by Roman on 13.10.2022.
//

import Foundation

struct Post: Identifiable, Codable {
  var title: String
  var content: String
  var authorName: String
  var timestamp = Date()
  var id = UUID()

  func contains(_ string: String) -> Bool {
      let properties = [title, content, authorName].map { $0.lowercased() }
      let query = string.lowercased()

      let matches = properties.filter { $0.contains(query) }
      return !matches.isEmpty
  }
}

extension Post {
    static let testPost = Post(
        title: "Lorem ipsum",
        content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
        authorName: "Jamie Harris"
    )
}
