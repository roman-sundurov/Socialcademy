//
//  PostsList.swift
//  Socialcademy
//
//  Created by Roman on 13.10.2022.
//

import SwiftUI

struct PostsList: View {
    private var posts = [Post.testPost]

  var body: some View {
          NavigationView {
              List(posts) { post in
                PostRow(post: post)
              }
              .navigationTitle("Posts")
          }
      }
}

struct PostsList_Previews: PreviewProvider {
    static var previews: some View {
        PostsList()
    }
}
