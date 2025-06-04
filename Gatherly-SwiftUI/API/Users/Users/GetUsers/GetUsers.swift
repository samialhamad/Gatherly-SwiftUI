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
        guard let currentUser = UserDefaultsManager.loadCurrentUser(),
              currentUser.id == id
        else {
            return Just([])
                .delay(for: .seconds(2), scheduler: DispatchQueue.main)
                .eraseToAnyPublisher()
        }
        
        let allUsers = UserDefaultsManager.loadUsers()
        let friends: [User] = currentUser.friendIDs?.compactMap { allUsers[$0] } ?? []
        
        return Just(friends)
            .delay(for: .seconds(2), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
