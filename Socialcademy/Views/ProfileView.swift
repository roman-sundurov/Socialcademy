//
//  ProfileView.swift
//  Socialcademy
//
//  Created by Roman on 15.11.2022.
//

import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @StateObject var viewModel: ProfileViewModel

    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                ProfileImage(url: viewModel.imageURL)
                    .frame(width: 200, height: 200)
                Spacer()
                Text(viewModel.name)
                    .font(.title2)
                    .bold()
                    .padding()
                ImagePickerButton(imageURL: $viewModel.imageURL) {
                    Label("Choose Image", systemImage: "photo.fill")
                }
                Spacer()
            }
            .navigationTitle("Profile")
            .toolbar {
                Button("Sign Out", action: {
                    viewModel.signOut()
                })
            }
        }
        .alert("Error", error: $viewModel.error)
        .disabled(viewModel.isWorking)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(
            viewModel: ProfileViewModel(
                user: User.testUser,
                authService: AuthService()
            )
        )
    }
}
