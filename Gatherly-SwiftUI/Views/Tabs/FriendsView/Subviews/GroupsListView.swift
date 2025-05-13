//
//  GroupsListView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/24/25.
//

import SwiftUI

struct GroupsListView: View {
    @EnvironmentObject var session: AppSession
    @Binding var searchText: String
    
    private var currentUser: User? {
        session.currentUser
    }
    
    private var groups: [UserGroup] {
        session.groups
    }
    
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
        guard let currentUser else {
            return []
        }
        
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
            NavigationLink(destination: GroupDetailView(group: group)) {
                GroupRow(group: group)
            }
        }
    }
}

#Preview {
    GroupsListView(searchText: .constant(""))
        .environmentObject(AppSession())
}
