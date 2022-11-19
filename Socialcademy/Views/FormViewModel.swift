//
//  FormViewModel.swift
//  Socialcademy
//
//  Created by Roman on 17.11.2022.
//

import Foundation

@MainActor
@dynamicMemberLookup
class FormViewModel<Value>: ObservableObject {
    typealias Action = (Value) async throws -> Void

    @Published var value: Value
    @Published var error: Error?
  @Published var isWorking = false

    subscript<T>(dynamicMember keyPath: WritableKeyPath<Value, T>) -> T {
        get { value[keyPath: keyPath] }
        set { value[keyPath: keyPath] = newValue }
    }

    private let action: Action

    init(initialValue: Value, action: @escaping Action) {
        self.value = initialValue
        self.action = action
    }

  nonisolated func submit() {
      Task {
          await handleSubmit()
      }
  }

  private func handleSubmit() async {
    isWorking = true
      do {
          try await action(value)
      } catch {
          print("[FormViewModel] Cannot submit: \(error)")
          self.error = error
      }
    isWorking = false
  }

}
