//
//  GroupsListView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/24/25.
//

import SwiftUI

struct GroupsListView: View {
    @ObservedObject var currentUser: User
    @Binding var groups: [UserGroup]
    @Binding var searchText: String
    
    let users: [User]
    
    var body: some View {
        List {
            groupListContent
        }
        .listStyle(.plain)
    }
}

private extension GroupsListView {
    
    //MARK: - Computed var
    
    var filteredGroups: [UserGroup] {
        let userGroups = groups.filter { group in
            let isLeader = (group.leaderID == currentUser.id)
            let isMember = currentUser.groupIDs?.contains(group.id) ?? false
            return isLeader || isMember
        }
        
        if searchText.isEmpty {
            return userGroups
        } else {
            let lowercasedQuery = searchText.lowercased()
            
            return userGroups.filter {
                $0.name.lowercased().contains(lowercasedQuery)
            }
        }
    }
    
    // MARK: - Functions
    
    func shouldShowGroup(_ group: UserGroup) -> Bool {
        let isLeader = (group.leaderID == currentUser.id)
        let isMember = currentUser.groupIDs?.contains(group.id) ?? false
        let matchesRole = isLeader || isMember
        
        if searchText.isEmpty {
            return matchesRole
        } else {
            return matchesRole && group.name.lowercased().contains(searchText.lowercased())
        }
    }
    
    //MARK: - Subviews
    
    var groupListContent: some View {
        ForEach($groups, id: \.id) { $group in
            if shouldShowGroup(group) {
                NavigationLink(destination: GroupDetailView(
                    group: $group,
                    groups: $groups,
                    currentUser: currentUser,
                    users: users
                )) {
                    GroupRow(group: group)
                }
            }
        }
    }
}

#Preview {
    if let sampleUser = SampleData.sampleUsers.first {
        GroupsListView(
            currentUser: sampleUser,
            groups: .constant(SampleData.sampleGroups),
            searchText: .constant(""),
            users: SampleData.sampleUsers
        )
    }
}
