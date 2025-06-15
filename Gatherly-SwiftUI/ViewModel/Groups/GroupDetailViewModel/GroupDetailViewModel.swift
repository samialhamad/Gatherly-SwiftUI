//
//  GroupDetailViewModel.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 6/7/25.
//

import SwiftUI

class GroupDetailViewModel: ObservableObject {
    
    // MARK: Computed Vars
    
    func friendsDict(for users: [User]) -> [Int: User] {
        users.keyedBy(\.id)
    }
    
    func group(forID id: Int, in groups: [UserGroup]) -> UserGroup? {
        groups.first { $0.id == id }
    }
    
    // MARK: Functions
    
    func leader(
        for group: UserGroup,
        currentUser: User?,
        friendsDict: [Int: User]
    ) -> User? {
        if let currentUser, group.leaderID == currentUser.id {
            return currentUser
        } else {
            return friendsDict[group.leaderID]
        }
    }
    
    func members(
        for group: UserGroup,
        currentUser: User?,
        friendsDict: [Int: User]
    ) -> [User] {
        group.memberIDs
            .filter { $0 != group.leaderID }
            .compactMap { id in
            if let currentUser, id == currentUser.id {
                return currentUser
            } else {
                return friendsDict[id]
            }
        }
    }
}
