//
//  AuthView.swift
//  Socialcademy
//
//  Created by Roman on 15.11.2022.
//

import SwiftUI

enum AuthForm {
    case signInForm
    case createAccount
}

struct AuthView: View {
    @StateObject var viewModel = AuthViewModel()
    @State var authForm = AuthForm.signInForm

  var body: some View {
    if let user = viewModel.user {
      MainTabView()
        .environmentObject(ViewModelFactory(user: user))
    } else {
        NavigationView {
            switch authForm {
            case .signInForm:
                SignInForm(viewModel: viewModel.makeSignInViewModel(), authForm: $authForm)
            case .createAccount:
                CreateAccountForm(viewModel: viewModel.makeCreateAccountViewModel(), authForm: $authForm)
            }
        }
    }
  }
}

// private extension AuthView {
//   struct Form<Content: View, Footer: View>: View {
//     @ViewBuilder let content: () -> Content
//     @ViewBuilder let footer: () -> Footer
// 
//     var body: some View {
//       VStack {
//         Text("Socialcademy")
//           .font(.title.bold())
//         content()
//           .padding()
//           .background(Color.secondary.opacity(0.15))
//           .cornerRadius(10)
//         footer()
//       }
//       .navigationBarHidden(true)
//       .padding()
//     }
//   }
// }

private extension AuthView {
    struct CreateAccountForm: View {
        @Environment(\.dismiss) private var dismiss
        @StateObject var viewModel: AuthViewModel.CreateAccountViewModel
        @Binding var authForm: AuthForm

        var body: some View {
            VStack {
              Text("Socialcademy")
                .font(.title.bold())
                Group {
                    TextField("Name", text: $viewModel.name)
                        .textContentType(.name)
                    TextField("Email", text: $viewModel.email)
                        .textContentType(.emailAddress)
                    SecureField("Password", text: $viewModel.password)
                        .textContentType(.newPassword)
                }
                .padding()
                .background(Color.secondary.opacity(0.15))
                .cornerRadius(10)

                Button("Create Account", action: viewModel.submit)
                    .buttonStyle(.primary)
                Button("Sign In", action: {
                    authForm = .signInForm

                })
            }
            .padding()
            .onSubmit(viewModel.submit)
            .alert("Cannot Create Account", error: $viewModel.error)
            .disabled(viewModel.isWorking)
        }
    }
}

private extension AuthView {
    struct SignInForm: View {
        @StateObject var viewModel: AuthViewModel.SignInViewModel
        @Binding var authForm: AuthForm

        var body: some View {
            VStack {
                Text("Socialcademy")
                    .font(.title.bold())
                Group {
                    TextField("Email", text: $viewModel.email)
                        .textContentType(.emailAddress)
                    SecureField("Password", text: $viewModel.password)
                        .textContentType(.password)
                }
                .padding()
                .background(Color.secondary.opacity(0.15))
                .cornerRadius(10)

                Button("Sign In", action: viewModel.submit)
                    .buttonStyle(.primary)
                Button("Create Account", action: {
                    authForm = .createAccount
                })
            }
            .padding()
            .onSubmit(viewModel.submit)
            .alert("Cannot Sign In", error: $viewModel.error)
            .disabled(viewModel.isWorking)
        }
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
    }
}
