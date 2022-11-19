//
//  AuthService.swift
//  Socialcademy
//
//  Created by Roman on 15.11.2022.
//

import Foundation
import FirebaseAuth

@MainActor
class AuthService: ObservableObject {
  @Published var isAuthenticated = false

  private let auth = Auth.auth()
  private var listener: AuthStateDidChangeListenerHandle?

  init() {
    listener = auth.addStateDidChangeListener { [weak self] _, user in
      self?.isAuthenticated = user != nil
    }
  }

  func createAccount(name: String, email: String, password: String) async throws {
    let result = try await auth.createUser(withEmail: email, password: password)
    try await result.user.updateProfile(\.displayName, to: name)
  }

  func signIn(email: String, password: String) async throws {
      try await auth.signIn(withEmail: email, password: password)
  }

  func signOut() throws {
      try auth.signOut()
  }

}

private extension FirebaseAuth.User {
    func updateProfile<T>(_ keyPath: WritableKeyPath<UserProfileChangeRequest, T>, to newValue: T) async throws {
        var profileChangeRequest = createProfileChangeRequest()
        profileChangeRequest[keyPath: keyPath] = newValue
        try await profileChangeRequest.commitChanges()
    }
}
