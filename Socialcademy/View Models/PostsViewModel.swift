//
//  PostsViewModel.swift
//  Socialcademy
//
//  Created by Roman on 15.10.2022.
//

import Foundation

@MainActor
class PostsViewModel: ObservableObject {

  enum Filter {
      case all, favorites
  }
  
  @Published var posts: Loadable<[Post]> = .loading
  private let postsRepository: PostsRepositoryProtocol
  private let filter: Filter
  var title: String {
      switch filter {
      case .all:
          return "Posts"
      case .favorites:
          return "Favorites"
      }
  }

  init(filter: Filter = .all, postsRepository: PostsRepositoryProtocol) {
      self.filter = filter
      self.postsRepository = postsRepository
  }

  func makeNewPostViewModel() -> FormViewModel<Post> {
      return FormViewModel(
          initialValue: Post(title: "", content: "", author: postsRepository.user),
          action: { [weak self] post in
              try await self?.postsRepository.create(post)
              self?.posts.value?.insert(post, at: 0)
          }
      )
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

  func fetchPosts() {
      Task {
          do {
            posts = .loaded(try await postsRepository.fetchPosts(matching: filter))
          } catch {
            print("[PostsViewModel] Cannot fetch posts: \(error)")
            posts = .error(error)
          }
      }
  }

}

private extension PostsRepositoryProtocol {
    func fetchPosts(matching filter: PostsViewModel.Filter) async throws -> [Post] {
        switch filter {
        case .all:
            return try await fetchAllPosts()
        case .favorites:
            return try await fetchFavoritePosts()
        }
    }
}
