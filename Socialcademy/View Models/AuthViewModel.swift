//
//  AuthViewModel.swift
//  Socialcademy
//
//  Created by Roman on 15.11.2022.
//

import Foundation

@MainActor
class AuthViewModel: ObservableObject {
    // @Published var isAuthenticated = false
    @Published var user: User?

    private let authService = AuthService()

    init() {
        authService.$user.assign(to: &$user)
    }

    func makeSignInViewModel() -> SignInViewModel {
        return SignInViewModel(action: authService.signIn(email:password:))
    }

    func makeCreateAccountViewModel() -> CreateAccountViewModel {
        return CreateAccountViewModel(action: authService.createAccount(name:email:password:))
    }

    func makeViewModelFactory() -> ViewModelFactory? {
        guard let user = user else {
            return nil
        }
        return ViewModelFactory(user: user, authService: authService)
    }

}

extension AuthViewModel {
    class SignInViewModel: FormViewModel<(email: String, password: String)> {
        convenience init(action: @escaping Action) {
            self.init(initialValue: (email: "", password: ""), action: action)
        }
    }
    
    class CreateAccountViewModel: FormViewModel<(name: String, email: String, password: String)> {
        convenience init(action: @escaping Action) {
            self.init(initialValue: (name: "", email: "", password: ""), action: action)
        }
    }
}
