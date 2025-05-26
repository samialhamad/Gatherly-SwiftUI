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
        let currentUser = users.first(where: { $0.id == id })
        let friends = users.filter { user in
            guard let userID = user.id else {
                return false
            }
            
            return currentUser?.friendIDs?.contains(userID) == true
        }
        
        return Just(friends)
            .delay(for: .seconds(2), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
