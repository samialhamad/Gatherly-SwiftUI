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
        var newUser = assignIDIfNeeded(user)
        var users = UserDefaultsManager.loadUsers()
        
        if let id = newUser.id {
            users[id] = newUser
        }
        
        UserDefaultsManager.saveUsers(users)
        
        return Just(newUser)
            .delay(for: .seconds(GatherlyAPI.delayTime), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    // MARK: - Create from Synced Contact
    
    static func createUser(from contact: SyncedContact, id: Int) async -> User {
        let user = User(
            createdTimestamp: Int(Date().timestamp),
            eventIDs: [],
            firstName: contact.fullName.components(separatedBy: " ").first,
            friendIDs: [],
            groupIDs: [],
            id: id,
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
        let existingIDs = Set(UserDefaultsManager.loadUsers().keys)
        var newID = (existingIDs.max() ?? 999) + 1
        while existingIDs.contains(newID) {
            newID += 1
        }
        newUser.id = newID
        return newUser
    }
}
