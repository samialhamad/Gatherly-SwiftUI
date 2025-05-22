//
//  CreateGroup.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 5/8/25.
//

import Combine
import Foundation

extension GatherlyAPI {
    static func createGroup(_ group: UserGroup) -> AnyPublisher<UserGroup, Never> {
        var storedGroup = group
        
        if storedGroup.id == nil {
            storedGroup.id = generateID()
        }
        
        var groups = UserDefaultsManager.loadGroups()
        groups.append(storedGroup)
        UserDefaultsManager.saveGroups(groups)
        
        return Just(storedGroup)
            .delay(for: .seconds(2), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
