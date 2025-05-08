//
//  UpdateGroup.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 5/8/25.
//

import Foundation

extension GatherlyAPI {
    static func updateGroup(
        _ originalGroup: UserGroup,
        name: String,
        memberIDs: Set<Int>,
        imageName: String? = nil,
        bannerImageName: String? = nil
    ) async -> UserGroup {
        var updatedGroup = originalGroup
        updatedGroup.name = name
        updatedGroup.memberIDs = Array(memberIDs).sorted()
        updatedGroup.imageName = imageName
        updatedGroup.bannerImageName = bannerImageName

        var groups = UserDefaultsManager.loadGroups()
        if let index = groups.firstIndex(where: { $0.id == originalGroup.id }) {
            groups[index] = updatedGroup
            UserDefaultsManager.saveGroups(groups)
        }

        await simulateNetworkDelay()
        return updatedGroup
    }
}
