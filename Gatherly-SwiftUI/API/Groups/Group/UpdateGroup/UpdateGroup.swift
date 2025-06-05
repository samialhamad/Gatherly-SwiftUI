//
//  UpdateGroup.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 5/8/25.
//

import Combine
import Foundation

extension GatherlyAPI {
    static func updateGroup(_ group: UserGroup) -> AnyPublisher<UserGroup, Never> {
        var groups = UserDefaultsManager.loadGroups()
        
        if let id = group.id {
            groups[id] = group
            UserDefaultsManager.saveGroups(groups)
        }
        
        return Just(group)
            .delay(for: .seconds(GatherlyAPI.delayTime), scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
