//
//  GetUsers.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 4/14/25.
//

import Combine
import Foundation

extension GatherlyAPI {
    static func getUsers(forUserID id: Int = 1) -> AnyPublisher<[User], Never> {
        let users = UserDefaultsManager.loadUsers()
        
        guard let currentUser = users[id] else {
            return Just([])
                .delay(for: .seconds(2), scheduler: DispatchQueue.main)
                .eraseToAnyPublisher()
        }
        
        let friends: [User] = currentUser.friendIDs?
            .compactMap { users[$0] } ?? []
        
        return Just(friends)
            .delay(for: .seconds(2), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
