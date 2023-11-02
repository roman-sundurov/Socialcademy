//
//  StateManager.swift
//  Socialcademy
//
//  Created by Roman on 18.04.2023.
//

import Foundation

@MainActor
protocol StateManager: AnyObject {
    var error: Error? { get set }
    var isWorking: Bool { get set }
}

extension StateManager {
    typealias Action = () async throws -> Void

    var isWorking: Bool {
        get { false }
        set {}
    }

    private func withStateManagement(perform action: @escaping Action) async {
        isWorking = true
        do {
            try await action()
        } catch {
            print("[\(Self.self)] Error: \(error)")
            self.error = error
        }
        isWorking = false
    }

    nonisolated func withStateManagingTask(perform action: @escaping () async throws -> Void) {
        Task {
            await withStateManagement(perform: action)
            // do {
            //     try await action()
            // } catch {
            //     print("[\(Self.self)] Error: \(error)")
            //     self.error = error
            // }
        }
    }
}
