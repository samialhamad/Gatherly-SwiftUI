//
//  DeleteUser.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 5/18/25.
//

import Combine
import Foundation

extension GatherlyAPI {
    static func deleteUser(_ user: User) -> AnyPublisher<Bool, Never> {
        var users = UserDefaultsManager.loadUsers()
        
        let existed = (user.id != nil && users.keys.contains(user.id!))
        if let id = user.id {
            users.removeValue(forKey: id)
            UserDefaultsManager.saveUsers(users)
        }
        
        return Just(existed)
            .eraseToAnyPublisher()
    }
}
