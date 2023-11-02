//
//  MainTabView.swift
//  Socialcademy
//
//  Created by Roman on 10.11.2022.
//

import SwiftUI

struct MainTabView: View {

    @EnvironmentObject private var factory: ViewModelFactory

    var body: some View {
        TabView {
            NavigationView {
                PostsList(viewModel: factory.makePostsViewModel())
            }
            .tabItem {
                Label("Posts", systemImage: "list.dash")
            }
            NavigationView {
                PostsList(viewModel: factory.makePostsViewModel(filter: .favorites))
            }
            .tabItem {
                Label("Favorites", systemImage: "heart")
            }
            ProfileView(viewModel: factory.makeProfileViewModel())
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
      MainTabView()
        .environmentObject(ViewModelFactory.preview)
    }
}
