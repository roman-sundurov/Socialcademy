//
//  PostsList.swift
//  Socialcademy
//
//  Created by Roman on 13.10.2022.
//

import SwiftUI

struct PostsList: View {
  // private var posts = [Post.testPost]
  @StateObject var viewModel = PostsViewModel()
  @State private var searchText = ""
  @State private var showNewPostForm = false

  var body: some View {
          NavigationView {
              List(viewModel.posts) { post in
                if searchText.isEmpty || post.contains(searchText) {
                  PostRow(post: post)
                }
              }
              .navigationTitle("Posts")
              .toolbar {
                  Button {
                      showNewPostForm = true
                  } label: {
                      Label("New Post", systemImage: "square.and.pencil")
                  }
              }
              .searchable(text: $searchText)
          }
          // .sheet(isPresented: $showNewPostForm) {
              // NewPostForm(createAction: { _ in })
          .sheet(isPresented: $showNewPostForm) {
              NewPostForm(createAction: viewModel.makeCreateAction())
          }
      }
}

struct PostsList_Previews: PreviewProvider {
    static var previews: some View {
        PostsList()
    }
}
