//
//  UpdateUser.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 5/8/25.
//

import Foundation

extension GatherlyAPI {
    static func updateUser(_ user: User) async -> User {
        var users = UserDefaultsManager.loadUsers()
        
        guard let id = user.id,
              let index = users.firstIndex(where: { $0.id == id }) else {
            return user
        }

        users[index] = user
        UserDefaultsManager.saveUsers(users)

        await simulateNetworkDelay()
        return user
    }
}
