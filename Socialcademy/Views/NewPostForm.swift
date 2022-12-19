//
//  NewPostForm.swift
//  Socialcademy
//
//  Created by Roman on 14.10.2022.
//

import SwiftUI

struct NewPostForm: View {
    // @State private var state = FormState.idle
    // @State private var post = Post(title: "", content: "", authorName: "")
    // let createAction: CreateAction
  typealias CreateAction = (Post) async throws -> Void

  @StateObject var viewModel: FormViewModel<Post>
  @Environment(\.dismiss) private var dismiss

  var body: some View {
    NavigationView {
      Form {
        Section {
          TextField("Title", text: $viewModel.title)
        }
        Section("Content") {
          TextEditor(text: $viewModel.content)
            .multilineTextAlignment(.leading)
        }
        Button(action: viewModel.submit) {
          if viewModel.isWorking {
            ProgressView()
          } else {
            Text("Create Post")
          }
        }
        .font(.headline)
        .frame(maxWidth: .infinity)
        .foregroundColor(.white)
        .padding()
        .listRowBackground(Color.accentColor)
      }
      .onSubmit(viewModel.submit)
      .navigationTitle("New Post")
      .onChange(of: viewModel.isWorking) { isWorking in
        guard !isWorking, viewModel.error == nil else { return }
        dismiss()
      }
    }
    .disabled(viewModel.isWorking)
    .alert("Cannot Create Post", error: $viewModel.error)
  }
}


struct NewPostForm_Previews: PreviewProvider {
    static var previews: some View {
      NewPostForm(viewModel: FormViewModel(initialValue: Post.testPost, action: { _ in} ))

    }
}
