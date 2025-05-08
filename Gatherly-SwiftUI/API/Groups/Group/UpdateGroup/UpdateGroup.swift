//
//  UpdateGroup.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 5/8/25.
//

import Foundation

extension GatherlyAPI {
    static func updateGroup(_ group: UserGroup) async -> UserGroup {
        var groups = UserDefaultsManager.loadGroups()
        
        if let id = group.id,
           let index = groups.firstIndex(where: { $0.id == id }) {
            groups[index] = group
            UserDefaultsManager.saveGroups(groups)
        }
        
        await simulateNetworkDelay()
        return group
    }
}
