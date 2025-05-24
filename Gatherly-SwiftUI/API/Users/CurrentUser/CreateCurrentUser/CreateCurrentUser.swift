//
//  CreateCurrentUser.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 5/23/25.
//

import Combine
import Foundation

extension GatherlyAPI {
    static func createCurrentUser(_ user: User) -> AnyPublisher<User, Never> {
        var storedUser = user
        if storedUser.id == nil {
            storedUser.id = generateID()
        }
        
        UserDefaultsManager.saveCurrentUser(storedUser)
        
        return Just(storedUser)
            .delay(for: .seconds(2), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
