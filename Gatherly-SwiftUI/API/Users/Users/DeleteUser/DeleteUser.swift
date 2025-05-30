//
//  DeleteUser.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 5/18/25.
//

import Combine
import Foundation

extension GatherlyAPI {
    static func deleteUser(_ userToDelete: User) -> AnyPublisher<Bool, Never> {
        var users = UserDefaultsManager.loadUsers()
        let originalCount = users.count
        
        users.removeAll { $0.id == userToDelete.id }
        UserDefaultsManager.saveUsers(users)
        
        return Just(users.count < originalCount)
            .eraseToAnyPublisher()
    }
}
