//
//  DeleteUser.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 5/18/25.
//

import Combine
import Foundation

extension GatherlyAPI {
    static func deleteUser(id: Int) -> AnyPublisher<Bool, Never> {
        var users = UserDefaultsManager.loadUsers()
        
        let existed = users.keys.contains(id)
        if existed {
            users.removeValue(forKey: id)
            UserDefaultsManager.saveUsers(users)
        }
        
        return Just(existed)
            .eraseToAnyPublisher()
    }
}
