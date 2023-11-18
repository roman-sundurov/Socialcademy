//
//  ProfileViewModel.swift
//  Socialcademy
//
//  Created by Roman on 1/11/23.
//

import Foundation

@MainActor
class ProfileViewModel: ObservableObject, StateManager {
    @Published var isWorking = false
    @Published var name: String
    @Published var imageURL: URL? {
        didSet {
            imageURLDidChange(from: oldValue)
        }
    }
    @Published var error: Error?

    private let authService: AuthService

    init(user: User, authService: AuthService) {
        self.name = user.name
        self.imageURL = user.imageURL
        self.authService = authService
    }

    func signOut() {
        withStateManagingTask(perform: authService.signOut)
    }

    private func imageURLDidChange(from oldValue: URL?) {
        guard imageURL != oldValue else { return }
        withStateManagingTask { [self] in
            try await authService.updateProfileImage(to: imageURL)
        }
    }
}
