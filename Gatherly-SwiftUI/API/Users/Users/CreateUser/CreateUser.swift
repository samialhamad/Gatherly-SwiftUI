//
//  CreateUser.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 5/8/25.
//

import Combine
import Foundation

extension GatherlyAPI {
    
    // MARK: - Create Manually
    
    static func createUser(_ user: User) -> AnyPublisher<User, Never> {
        var storedUser = assignIDIfNeeded(user)
        
        var users = UserDefaultsManager.loadUsers()
        users = deduplicatedUsersAppended(existing: users, newUser: storedUser)
        UserDefaultsManager.saveUsers(users)
        
        return Just(storedUser)
            .delay(for: .seconds(2), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    // MARK: - Create from Synced Contact
    
    static func createUser(from contact: SyncedContact, id: Int) async -> User {
        let user = User(
            createdTimestamp: Int(Date().timeIntervalSince1970),
            email: nil,
            eventIDs: [],
            firstName: contact.fullName.components(separatedBy: " ").first,
            friendIDs: [],
            groupIDs: [],
            id: id,
            isEmailEnabled: false,
            lastName: contact.fullName.components(separatedBy: " ").dropFirst().joined(separator: " "),
            phone: contact.phoneNumber
        )
        
        return await withCheckedContinuation { continuation in
            var cancellable: AnyCancellable?
            
            cancellable = createUser(user)
                .sink { created in
                    continuation.resume(returning: created)
                    cancellable = nil
                }
        }
    }
    
    // MARK: - Helpers
    
    private static func assignIDIfNeeded(_ user: User) -> User {
        guard user.id == nil else {
            return user
        }
        
        var newUser = user
        let existingIDs = Set(UserDefaultsManager.loadUsers().compactMap { $0.id })
        var newID = (existingIDs.max() ?? 999) + 1
        while existingIDs.contains(newID) {
            newID += 1
        }
        newUser.id = newID
        return newUser
    }
    
    private static func deduplicatedUsersAppended(existing users: [User], newUser: User) -> [User] {
        let filtered = users.filter { $0.id != newUser.id }
        return filtered + [newUser]
    }
}
