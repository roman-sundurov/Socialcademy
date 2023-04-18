//
//  PostRowViewModel.swift
//  Socialcademy
//
//  Created by Roman on 10.11.2022.
//

import Foundation

@MainActor
@dynamicMemberLookup
class PostRowViewModel: ObservableObject, ErrorHandler {
  typealias Action = () async throws -> Void

  var canDeletePost: Bool { deleteAction != nil }

  subscript<T>(dynamicMember keyPath: KeyPath<Post, T>) -> T {
      post[keyPath: keyPath]
  }

  @Published var post: Post
  @Published var error: Error?

  private let deleteAction: Action?
  private let favoriteAction: Action

  init(post: Post, deleteAction: Action?, favoriteAction: @escaping Action) {
    self.post = post
    self.deleteAction = deleteAction
    self.favoriteAction = favoriteAction
  }

  private func withErrorHandlingTask(perform action: @escaping Action) {
      Task {
          do {
              try await action()
          } catch {
              print("[PostRowViewModel] Error: \(error)")
              self.error = error
          }
      }
  }

  func deletePost() {
    guard let deleteAction = deleteAction else {
      preconditionFailure("Cannot delete post: no delete action provided")
    }
    withErrorHandlingTask(perform: deleteAction)
  }

  func favoritePost() {
      withErrorHandlingTask(perform: favoriteAction)
  }

}
