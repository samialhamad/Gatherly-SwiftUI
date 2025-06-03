//
//  DeleteGroup.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 5/8/25.
//

import Combine
import Foundation

extension GatherlyAPI {
    static func deleteGroup(_ group: UserGroup) -> AnyPublisher<Bool, Never> {
        var groups = UserDefaultsManager.loadGroups()
        
        let existed = (group.id != nil && groups.keys.contains(group.id!))
        
        if let id = group.id {
            groups.removeValue(forKey: id)
            UserDefaultsManager.saveGroups(groups)
        }
        
        return Just(existed)
            .eraseToAnyPublisher()
    }
}
