//
//  Loadable.swift
//  Socialcademy
//
//  Created by Roman on 15.10.2022.
//

import Foundation

enum Loadable<Value> {
  case loading
  case error(Error)
  case loaded(Value)

  var value: Value? {
    get {
      if case let .loaded(value) = self {
        return value
      }
      return nil
    }
    set {
      guard let newValue = newValue else { return }
      self = .loaded(newValue)
    }
  }
}

extension Loadable where Value: RangeReplaceableCollection {
    static var empty: Loadable<Value> { .loaded(Value()) }
}

extension Loadable: Equatable where Value: Equatable {
    static func == (lhs: Loadable<Value>, rhs: Loadable<Value>) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading):
            return true
        case let (.error(error1), .error(error2)):
            return error1.localizedDescription == error2.localizedDescription
        case let (.loaded(value1), .loaded(value2)):
            return value1 == value2
        default:
            return false
        }
    }
}

#if DEBUG
extension Loadable {

  static var error: Loadable<Value> { .error(PreviewError()) }

  private struct PreviewError: LocalizedError {
      let errorDescription: String? = "Lorem ipsum dolor set amet."
  }

  func simulate() async throws -> Value {
      switch self {
      case .loading:
          try await Task.sleep(nanoseconds: 10 * 1_000_000_000)
          fatalError("Timeout exceeded for “loading” case preview")
      case let .error(error):
          throw error
      case let .loaded(value):
          return value
      }
  }

}
#endif
