//
//  GroupsAPI.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 5/7/25.
//

import Foundation

extension GatherlyAPI {
    
    // MARK: - Create Group

    static func createGroup(
        name: String,
        memberIDs: Set<Int>,
        imageName: String? = nil,
        bannerImageName: String? = nil,
        leaderID: Int
    ) async -> UserGroup {
        var groups = UserDefaultsManager.loadGroups()
        let nextID = (groups.map { $0.id }.max() ?? 0) + 1

        let group = UserGroup(
            bannerImageName: bannerImageName,
            id: nextID,
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

    // MARK: - Update Group

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

    // MARK: - Delete Group

    static func deleteGroup(_ groupToDelete: UserGroup) async -> [UserGroup] {
        var groups = UserDefaultsManager.loadGroups()
        groups.removeAll { $0.id == groupToDelete.id }
        UserDefaultsManager.saveGroups(groups)
        
        await simulateNetworkDelay()
        return groups
    }
    
    // MARK: - Simulate Delay
    
    private static func simulateNetworkDelay(seconds: Double = 1.0) async {
        let ns = UInt64(seconds * 1_000_000_000) // 1 second
        try? await Task.sleep(nanoseconds: ns)
    }
}
