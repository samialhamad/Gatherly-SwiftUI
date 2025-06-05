//
//  GetCurrentUser.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 5/23/25.
//

import Combine
import Foundation

extension GatherlyAPI {
    static func getCurrentUser() -> AnyPublisher<User?, Never> {
        let user = UserDefaultsManager.loadCurrentUser()
        
        return Just(user)
            .delay(for: .seconds(GatherlyAPI.delayTime), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
