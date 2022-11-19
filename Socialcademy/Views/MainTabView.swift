//
//  MainTabView.swift
//  Socialcademy
//
//  Created by Roman on 10.11.2022.
//

import SwiftUI

struct MainTabView: View {
  var body: some View {
    TabView {
      PostsList()
        .tabItem {
          Label("Posts", systemImage: "list.dash")
        }
      PostsList(viewModel: PostsViewModel(filter: .favorites))
        .tabItem {
          Label("Favorites", systemImage: "heart")
        }
      ProfileView()
        .tabItem {
          Label("Profile", systemImage: "person")
        }
    }
  }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
