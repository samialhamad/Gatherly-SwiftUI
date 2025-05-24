//
//  GetCurrentUser.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 5/23/25.
//

import Combine
import Foundation

extension GatherlyAPI {
    static func getCurrentUser(withID id: Int = 1) -> AnyPublisher<User?, Never> {
        let users = UserDefaultsManager.loadUsers()
        let user = users.first { $0.id == id }
        
        return Just(user)
            .delay(for: .seconds(2), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
