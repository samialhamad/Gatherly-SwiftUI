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
        var newGroup = group
        
        if newGroup.id == nil {
            newGroup.id = generateID()
        }
        
        var groups = UserDefaultsManager.loadGroups()
        
        if let id = newGroup.id {
            groups[id] = newGroup
        }
        
        UserDefaultsManager.saveGroups(groups)
        
        return Just(newGroup)
            .delay(for: .seconds(GatherlyAPI.delayTime), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
