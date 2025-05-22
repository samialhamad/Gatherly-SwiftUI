//
//  UpdateUser.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 5/8/25.
//

import Combine
import Foundation

extension GatherlyAPI {
    static func updateUser(_ user: User) -> AnyPublisher<User, Never> {
        var users = UserDefaultsManager.loadUsers()
        
        if let id = user.id,
           let index = users.firstIndex(where: { $0.id == id }) {
            users[index] = user
            UserDefaultsManager.saveUsers(users)
        }
        
        return Just(user)
            .delay(for: .seconds(2), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
