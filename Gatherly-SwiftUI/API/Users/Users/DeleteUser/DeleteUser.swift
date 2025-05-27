//
//  DeleteUser.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 5/18/25.
//

import Combine
import Foundation

extension GatherlyAPI {
    static func deleteUser(_ userToDelete: User) -> AnyPublisher<[User], Never> {
        var users = UserDefaultsManager.loadUsers()
        
        users.removeAll { $0.id == userToDelete.id }
        UserDefaultsManager.saveUsers(users)
        
        return Just(users)
            .eraseToAnyPublisher()
    }
}
