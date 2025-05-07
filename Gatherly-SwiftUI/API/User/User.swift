//
//  User.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 5/7/25.
//

import Combine
import Foundation

extension GatherlyAPI {
    
    // MARK: - Create Manually

    static func createUser(
        firstName: String,
        lastName: String,
        phone: String? = nil,
        email: String? = nil
    ) -> AnyPublisher<User, Never> {
        var users = UserDefaultsManager.loadUsers()
        let nextID = (users.map { $0.id ?? 0 }.max() ?? 999) + 1
        
        let user = User(
            createdTimestamp: Int(Date().timeIntervalSince1970),
            email: email,
            eventIDs: [],
            firstName: firstName,
            friendIDs: [],
            groupIDs: [],
            id: nextID,
            isEmailEnabled: false,
            lastName: lastName,
            phone: phone
        )
        
        users.append(user)
        UserDefaultsManager.saveUsers(users)
        return Just(user).eraseToAnyPublisher()
    }
    
    // MARK: - Create from Synced Contact
    
    static func createUser(from contact: SyncedContact, id: Int) -> AnyPublisher<User, Never> {
        let user = User(
            createdTimestamp: Int(Date().timeIntervalSince1970),
            eventIDs: [],
            firstName: contact.fullName.components(separatedBy: " ").first,
            friendIDs: [],
            groupIDs: [],
            id: id,
            isEmailEnabled: false,
            lastName: contact.fullName.components(separatedBy: " ").dropFirst().joined(separator: " "),
            phone: contact.phoneNumber
        )

        var users = UserDefaultsManager.loadUsers()
        users.append(user)
        UserDefaultsManager.saveUsers(users)
        return Just(user).eraseToAnyPublisher()
    }
    
    // MARK: - Update Existing User
    
    static func updateUser(
        _ user: User,
        firstName: String,
        lastName: String,
        avatarImageName: String? = nil,
        bannerImageName: String? = nil
    ) -> AnyPublisher<User, Never> {
        var users = UserDefaultsManager.loadUsers()
        guard let id = user.id else {
            return Just(user).eraseToAnyPublisher()
        }

        if let index = users.firstIndex(where: { $0.id == id }) {
            let updatedUser = users[index]
            updatedUser.firstName = firstName
            updatedUser.lastName = lastName
            updatedUser.avatarImageName = avatarImageName
            updatedUser.bannerImageName = bannerImageName

            users[index] = updatedUser
            UserDefaultsManager.saveUsers(users)
            return Just(updatedUser).eraseToAnyPublisher()
        }

        return Just(user).eraseToAnyPublisher()
    }
}
