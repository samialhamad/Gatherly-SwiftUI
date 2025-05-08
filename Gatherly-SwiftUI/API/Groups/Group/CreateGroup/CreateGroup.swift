//
//  CreateGroup.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 5/8/25.
//

import Foundation

extension GatherlyAPI {
    static func createGroup(_ group: UserGroup) async -> UserGroup {
        var storedGroup = group
        
        if storedGroup.id == nil {
            storedGroup.id = generateID()
        }
        
        var groups = UserDefaultsManager.loadGroups()
        groups.append(storedGroup)
        UserDefaultsManager.saveGroups(groups)
        
        await simulateNetworkDelay()
        return storedGroup
    }
}
