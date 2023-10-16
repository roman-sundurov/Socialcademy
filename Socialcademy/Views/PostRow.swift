//
//  PostRow.swift
//  Socialcademy
//
//  Created by Roman on 13.10.2022.
//

import SwiftUI

struct PostRow: View {
    @EnvironmentObject private var factory: ViewModelFactory
    @ObservedObject var viewModel: PostRowViewModel

    @State private var showConfirmationDialog = false
    @State private var error: Error?
    @State var imageURL2: URL?

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                AuthorView(author: viewModel.author)
                Spacer()
                Text(viewModel.timestamp.formatted(date: .abbreviated, time: .omitted))
                    .font(.caption)
            }
            .foregroundColor(.gray)
            if let imageURL = viewModel.imageURL {
                PostImage(url: imageURL)
            } else if let imageURL2 = imageURL2 {
                PostImage(url: imageURL2)
            }
            Text(viewModel.title)
                .font(.title3)
                .fontWeight(.semibold)
            Text(viewModel.content)
            HStack {
                FavoriteButton(isFavorite: viewModel.isFavorite, action: {
                    viewModel.favoritePost()
                })
                NavigationLink {
                    CommentsList(viewModel: factory.makeCommentsViewModel(for: viewModel.post))
                } label: {
                    Label("Comments", systemImage: "text.bubble")
                        .foregroundColor(.secondary)
                }
                Spacer()
                if viewModel.canDeletePost {
                    Button(role: .destructive, action: {
                        showConfirmationDialog = true
                    }) {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
            .labelStyle(.iconOnly)
            .onAppear {
                Task {
                    imageURL2 = try await StorageFile
                        .with(namespace: "posts", identifier: viewModel.id.uuidString)
                        .getDownloadURL()
                }
            }

        }
        .padding()
        .confirmationDialog("Are you sure you want to delete this post?", isPresented: $showConfirmationDialog, titleVisibility: .visible) {
            Button("Delete", role: .destructive, action: {
                viewModel.deletePost()
            })
        }
        .alert("Error", error: $viewModel.error)
    }

}

private extension PostRow {
    struct FavoriteButton: View {
        let isFavorite: Bool
        let action: () -> Void

        var body: some View {
            Button(action: action) {
                if isFavorite {
                    Label("Remove from Favorites", systemImage: "heart.fill")
                } else {
                    Label("Add to Favorites", systemImage: "heart")
                }
            }
            .foregroundColor(isFavorite ? .red : .gray)
            .animation(.default, value: isFavorite)
        }
    }

    struct AuthorView: View {
        let author: User

        @EnvironmentObject private var factory: ViewModelFactory

        var body: some View {
            NavigationLink {
                PostsList(viewModel: factory.makePostsViewModel(filter: .author(author)))
            } label: {
                Text(author.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
        }
    }

    struct PostImage: View {
        let url: URL

        var body: some View {
            AsyncImage(url: url) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            } placeholder: {
                Color.clear
            }
        }
    }
}

struct PostRow_Previews: PreviewProvider {
    static var previews: some View {
        PostRow(viewModel: PostRowViewModel(post: Post.testPost, deleteAction: {}, favoriteAction: {}))
            .previewLayout(.sizeThatFits)
    }
}
