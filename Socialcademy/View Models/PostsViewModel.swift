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

  func makePostRowViewModel(for post: Post) -> PostRowViewModel {
      return PostRowViewModel(
          post: post,
          deleteAction: { [weak self] in
              try await self?.postsRepository.delete(post)
              self?.posts.value?.removeAll { $0 == post }
          },
          favoriteAction: { [weak self] in
              let newValue = !post.isFavorite
              try await newValue ? self?.postsRepository.favorite(post) : self?.postsRepository.unfavorite(post)
              guard let i = self?.posts.value?.firstIndex(of: post) else { return }
              self?.posts.value?[i].isFavorite = newValue
          }
      )
  }

  // func makeFavoriteAction(for post: Post) -> PostRow.Action {
  //   return { [weak self] in
  //     let newValue = !post.isFavorite
  //     try await newValue ? self?.postsRepository.favorite(post) : self?.postsRepository.unfavorite(post)
  //     guard let i = self?.posts.value?.firstIndex(of: post) else { return }
  //     self?.posts.value?[i].isFavorite = newValue
  //   }
  // }
  // 
  // func makeDeleteAction(for post: Post) -> PostRow.Action {
  //   return { [weak self] in
  //     try await self?.postsRepository.delete(post)
  //     self?.posts.value?.removeAll { $0.id == post.id }
  //   }
  // }

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
