//
//  GroupsListViewModel.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/30/25.
//

import Foundation

// NOT BEING USED AT MOMENT

class GroupsListViewModel: ObservableObject {
    @Published var searchText: String = ""
    
    private let allUsers: [User]
    private var allUserGroups: [UserGroup]
    private var currentUserID: Int
    
    //needs to change in future
    init(currentUserID: Int = 1,
         allUsers: [User] = SampleData.sampleUsers,
         allUserGroups: [UserGroup] = SampleData.sampleGroups) {
        self.currentUserID = currentUserID
        self.allUsers = allUsers
        self.allUserGroups = allUserGroups
    }
    
    // also needs to be revisited once sampleData is done away with
    var groups: [UserGroup] {
        guard let currentUser = allUsers.first(where: { $0.id == currentUserID }),
            let userGroupIDs = currentUser.groupIDs else {
            return []
        }
        return SampleData.sampleGroups.filter { userGroupIDs.contains($0.id) }
    }
    
    var filteredGroups: [UserGroup] {
        if searchText.isEmpty {
            return groups
        } else {
            let lowercasedQuery = searchText.lowercased()
            return groups.filter {
                $0.name.lowercased().contains(lowercasedQuery)
            }
        }
    }
}
