//
//  CommentRowViewModel.swift
//  Socialcademy
//
//  Created by Roman on 18.04.2023.
//

import Foundation

@MainActor
@dynamicMemberLookup
class CommentRowViewModel: ObservableObject, StateManager {
    @Published var comment: Comment
    @Published var error: Error?

    typealias Action = () async throws -> Void
    var canDeleteComment: Bool { deleteAction != nil }
    
    private let deleteAction: Action?

    subscript<T>(dynamicMember keyPath: KeyPath<Comment, T>) -> T {
        comment[keyPath: keyPath]
    }

    init(comment: Comment, deleteAction: Action?) {
        self.comment = comment
        self.deleteAction = deleteAction
    }

    func deleteComment() {
        guard let deleteAction = deleteAction else {
            preconditionFailure("Cannot delete comment: no delete action provided")
        }
        withStateManagingTask(perform: deleteAction)
    }

}
