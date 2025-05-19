//
//  DeleteUser.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 5/18/25.
//

import Foundation

extension GatherlyAPI {
    static func deleteUser(_ userToDelete: User) async -> [User] {
        var users = UserDefaultsManager.loadUsers()
        users.removeAll { $0.id == userToDelete.id }
        UserDefaultsManager.saveUsers(users)
        
        await simulateNetworkDelay()
        return users
    }
}
