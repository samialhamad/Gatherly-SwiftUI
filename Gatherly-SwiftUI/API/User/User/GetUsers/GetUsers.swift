//
//  GetUsers.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 4/14/25.
//

import Combine
import Foundation

extension GatherlyAPI {
    static func getUsers() -> AnyPublisher<[User], Never> {
        Just(UserDefaultsManager.loadUsers())
            .delay(for: .seconds(2), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
