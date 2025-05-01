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
    
    //MARK: - Subviews
    
    var groupListContent: some View {
        ForEach(filteredGroups, id: \.id) { group in
            NavigationLink(destination: GroupDetailView(
                groups: $groups,
                group: group,
                currentUser: currentUser,
                users: users
            )) {
                GroupRow(group: group)
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
