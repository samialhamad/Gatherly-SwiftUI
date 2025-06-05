//
//  UpdateCurrentUser.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 5/23/25.
//

import Combine
import Foundation

extension GatherlyAPI {
    static func updateCurrentUser(_ user: User) -> AnyPublisher<User, Never> {
        UserDefaultsManager.saveCurrentUser(user)
        
        return Just(user)
            .delay(for: .seconds(GatherlyAPI.delayTime), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
