//
//  SocialcademyApp.swift
//  Socialcademy
//
//  Created by Roman on 12.10.2022.
//

import SwiftUI
import Firebase

@main
struct SocialcademyApp: App {
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            PostsList()
        }
    }
}
