//
//  PostsViewModel.swift
//  Socialcademy
//
//  Created by Roman on 15.10.2022.
//

import Foundation

@MainActor
class PostsViewModel: ObservableObject {
  private let postsRepository: PostsRepositoryProtocol
  @Published var posts: Loadable<[Post]> = .loading

  init(postsRepository: PostsRepositoryProtocol = PostsRepository()) {
      self.postsRepository = postsRepository
  }

  func fetchPosts() {
      Task {
          do {
            posts = .loaded(try await postsRepository.fetchPosts())
          } catch {
            print("[PostsViewModel] Cannot fetch posts: \(error)")
            posts = .error(error)
          }
      }
  }

  func makeCreateAction() -> NewPostForm.CreateAction {
      return { [weak self] post in
        try await self?.postsRepository.create(post)
        self?.posts.value?.insert(post, at: 0)
      }
  }
}
