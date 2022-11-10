//
//  PostsRepository.swift
//  Socialcademy
//
//  Created by Roman on 15.10.2022.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol PostsRepositoryProtocol {
  func fetchAllPosts() async throws -> [Post]
  func fetchFavoritePosts() async throws -> [Post]
  func create(_ post: Post) async throws
  func delete(_ post: Post) async throws
  func favorite(_ post: Post) async throws
  func unfavorite(_ post: Post) async throws
}

struct PostsRepository: PostsRepositoryProtocol {
  let postsReference = Firestore.firestore().collection("posts_v1")

  func favorite(_ post: Post) async throws {
      let document = postsReference.document(post.id.uuidString)
      try await document.setData(["isFavorite": true], merge: true)
  }

  func unfavorite(_ post: Post) async throws {
      let document = postsReference.document(post.id.uuidString)
      try await document.setData(["isFavorite": false], merge: true)
  }

  private func fetchPosts(from query: Query) async throws -> [Post] {
      let snapshot = try await query
          .order(by: "timestamp", descending: true)
          .getDocuments()
      return snapshot.documents.compactMap { document in
          try! document.data(as: Post.self)
      }
  }

  func fetchAllPosts() async throws -> [Post] {
    return try await fetchPosts(from: postsReference)  }

  func fetchFavoritePosts() async throws -> [Post] {
    return try await fetchPosts(from: postsReference.whereField("isFavorite", isEqualTo: true))
  }

  func delete(_ post: Post) async throws {
    let document = postsReference.document(post.id.uuidString)
    try await document.delete()
  }

  func create(_ post: Post) async throws {
    let document = postsReference.document(post.id.uuidString)
    try await document.setData(from: post)
  }
}

private extension DocumentReference {
    func setData<T: Encodable>(from value: T) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            // Method only throws if there’s an encoding error, which indicates a problem with our model.
            // We handled this with a force try, while all other errors are passed to the completion handler.
            try! setData(from: value) { error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                continuation.resume()
            }
        }
    }
}

#if DEBUG
struct PostsRepositoryStub: PostsRepositoryProtocol {

  func favorite(_ post: Post) async throws {}
  func unfavorite(_ post: Post) async throws {}
  func delete(_ post: Post) async throws {
  }

  let state: Loadable<[Post]>

  func fetchAllPosts() async throws -> [Post] {
      return try await state.simulate()
  }

  func fetchFavoritePosts() async throws -> [Post] {
      return try await state.simulate()
  }

  func create(_ post: Post) async throws {}
}
#endif
