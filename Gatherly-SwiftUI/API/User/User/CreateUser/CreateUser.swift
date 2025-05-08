//
//  CreateUser.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 5/8/25.
//

import Foundation

extension GatherlyAPI {
    // MARK: - Create Manually

    static func createUser(
        firstName: String,
        lastName: String,
        phone: String? = nil,
        email: String? = nil
    ) async -> User {
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
        return user
    }
    
    // MARK: - Create from Synced Contact

    static func createUser(from contact: SyncedContact, id: Int) async -> User {
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
        return user
    }
}
