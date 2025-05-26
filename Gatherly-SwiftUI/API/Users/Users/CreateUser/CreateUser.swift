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
        var storedUser = user
        
        if storedUser.id == nil {
            storedUser.id = generateID()
        }
        
        var users = UserDefaultsManager.loadUsers()
        users.append(storedUser)
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
}
