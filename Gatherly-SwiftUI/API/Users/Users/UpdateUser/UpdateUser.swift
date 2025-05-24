//
//  UpdateUser.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 5/8/25.
//

import Combine
import Foundation

extension GatherlyAPI {
    static func updateUser(_ updatedUser: User) -> AnyPublisher<User, Never> {
        var users = UserDefaultsManager.loadUsers()
        
        if let index = users.firstIndex(where: { $0.id == updatedUser.id }) {
            users[index] = updatedUser
            UserDefaultsManager.saveUsers(users)
        }
        
        return Just(updatedUser)
            .delay(for: .seconds(2), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
