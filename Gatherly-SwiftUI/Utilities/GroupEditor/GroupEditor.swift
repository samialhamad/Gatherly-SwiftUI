//
//  GroupEditor.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 4/1/25.
//

import Foundation
import SwiftUI

struct GroupEditor {
    
    // MARK: - Save / Edit
    
    static func saveGroup(
        originalGroup: UserGroup? = nil,
        name: String,
        memberIDs: Set<Int>,
        imageName: String? = nil,
        bannerImageName: String? = nil,
        leaderID: Int,
        generateGroupID: () -> Int = { Int.random(in: 10000...99999) }
    ) -> UserGroup {
        
        let groupID = originalGroup?.id ?? generateGroupID()
        let leaderID = originalGroup?.leaderID ?? leaderID
        
        var group = UserGroup(
            id: groupID,
            name: name,
            memberIDs: Array(memberIDs).sorted(),
            leaderID: leaderID,
            messages: originalGroup?.messages
        )
        
        group.imageName = imageName
        group.bannerImageName = bannerImageName
        
        return group
    }
    
    // MARK: - Delete
    
    static func deleteGroup(from groups: [UserGroup], groupToDelete: UserGroup) -> [UserGroup] {
        groups.filter { $0.id != groupToDelete.id }
    }
    
    //MARK: - isFormEmpty
    static func isFormEmpty(name: String) -> Bool {
        name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
