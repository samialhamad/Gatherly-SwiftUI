//
//  GroupsListView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/24/25.
//

import SwiftUI

struct GroupsListView: View {
    let currentUser: User = SampleData.sampleUsers[0]
    
    @Binding var groups: [UserGroup]
    @Binding var searchText: String
    
    var body: some View {
        List {
            ForEach(filteredGroups, id: \.id) { group in
                NavigationLink(destination: GroupDetailView(group: group)) {
                    GroupRow(group: group)
                }
            }
        }
        .listStyle(.plain)
    }
}

//MARK: - Computed var

private extension GroupsListView {
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
}
