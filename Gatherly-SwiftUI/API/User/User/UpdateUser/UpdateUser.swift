//
//  UpdateUser.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 5/8/25.
//

import Foundation

extension GatherlyAPI {
    static func updateUser(
        _ user: User,
        firstName: String,
        lastName: String,
        avatarImageName: String? = nil,
        bannerImageName: String? = nil
    ) async -> User {
        var users = UserDefaultsManager.loadUsers()
        guard let id = user.id else {
            return user
        }
        
        if let index = users.firstIndex(where: { $0.id == id }) {
            let updatedUser = users[index]
            updatedUser.firstName = firstName
            updatedUser.lastName = lastName
            updatedUser.avatarImageName = avatarImageName
            updatedUser.bannerImageName = bannerImageName
            
            users[index] = updatedUser
            UserDefaultsManager.saveUsers(users)
            return updatedUser
        }
        
        return user
    }
}
