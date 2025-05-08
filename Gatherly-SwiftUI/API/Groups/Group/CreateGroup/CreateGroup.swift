//
//  CreateGroup.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 5/8/25.
//

import Foundation

extension GatherlyAPI {
    static func createGroup(
        name: String,
        memberIDs: Set<Int>,
        imageName: String? = nil,
        bannerImageName: String? = nil,
        leaderID: Int
    ) async -> UserGroup {
        var groups = UserDefaultsManager.loadGroups()

        let group = UserGroup(
            bannerImageName: bannerImageName,
            id: generateID(),
            imageName: imageName,
            leaderID: leaderID,
            memberIDs: Array(memberIDs).sorted(),
            messages: [],
            name: name
        )

        groups.append(group)
        UserDefaultsManager.saveGroups(groups)
        
        await simulateNetworkDelay()
        return group
    }
}
