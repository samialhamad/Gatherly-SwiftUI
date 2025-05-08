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
    
    let friendsDict: [Int: User]
    
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
            let isMember = group.id.flatMap { currentUser.groupIDs?.contains($0) } ?? false
            return isLeader || isMember
        }
        
        if searchText.isEmpty {
            return userGroups
        } else {
            let lowercasedQuery = searchText.lowercased()
            
            return userGroups.filter {
                ($0.name ?? "").lowercased().contains(lowercasedQuery)
            }
        }
    }
    
    //MARK: - Subviews
    
    var groupListContent: some View {
        ForEach(filteredGroups, id: \.id) { group in
            NavigationLink(destination: GroupDetailView(
                groups: $groups,
                currentUser: currentUser,
                friendsDict: friendsDict,
                group: group
            )) {
                GroupRow(group: group)
            }
        }
    }
}

#Preview {
    let sampleUsers = SampleData.sampleUsers
    let currentUser = sampleUsers.first!
    let friendsDict = Dictionary(uniqueKeysWithValues: sampleUsers.map { ($0.id ?? -1, $0) })

    return GroupsListView(
        currentUser: currentUser,
        groups: .constant(SampleData.sampleGroups),
        searchText: .constant(""),
        friendsDict: friendsDict
    )
}
