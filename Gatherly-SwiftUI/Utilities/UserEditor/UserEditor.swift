//
//  UserEditor.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 4/22/25.
//

import Foundation
import SwiftUI

struct UserEditor {
    
    static func saveUser(
        originalUser: User,
        firstName: String,
        lastName: String,
        avatarImageName: String? = nil,
        bannerImageName: String? = nil,
        existingUsers: [User]
    ) -> [User] {
        var updatedUsers = existingUsers
        var updatedUser = originalUser
        
        updatedUser.firstName = firstName
        updatedUser.lastName = lastName
        updatedUser.imageName = avatarImageName
        updatedUser.bannerImageName = bannerImageName
        
        if let index = updatedUsers.firstIndex(where: { $0.id == originalUser.id }) {
            updatedUsers[index] = updatedUser
        } else {
            updatedUsers.append(updatedUser)
        }
        
        UserDefaultsManager.saveUsers(updatedUsers)
        return updatedUsers
    }
}
