//
//  DeleteGroup.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 5/8/25.
//

import Foundation

extension GatherlyAPI {
    static func deleteGroup(_ groupToDelete: UserGroup) async -> [UserGroup] {
        var groups = UserDefaultsManager.loadGroups()
        groups.removeAll { $0.id == groupToDelete.id }
        UserDefaultsManager.saveGroups(groups)
        
        return groups
    }
}
