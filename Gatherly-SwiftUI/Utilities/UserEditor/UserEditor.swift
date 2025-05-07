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
        user: User,
        firstName: String,
        lastName: String,
        avatarImageName: String? = nil,
        bannerImageName: String? = nil
    ) -> User {
        user.firstName = firstName
        user.lastName = lastName
        user.avatarImageName = avatarImageName
        user.bannerImageName = bannerImageName
        
        UserDefaultsManager.saveUsers([user])
        return user
    }
}
