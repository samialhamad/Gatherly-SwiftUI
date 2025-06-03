//
//  GetGroups.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 4/14/25.
//

import Combine
import Foundation

extension GatherlyAPI {
    static func getGroups() -> AnyPublisher<[UserGroup], Never> {
        let groups = UserDefaultsManager.loadGroups()
        let groupsArray = Array(groups.values)

        return Just(groupsArray)
            .delay(for: .seconds(2), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
