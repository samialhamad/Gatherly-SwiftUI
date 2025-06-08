//
//  GroupsListViewModel.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 6/8/25.
//

import Foundation

class GroupsListViewModel: ObservableObject {
    
    func filteredGroups(
        from allGroups: [UserGroup],
        currentUser: User?,
        searchText: String
    ) -> [UserGroup] {
        guard let currentUser else {
            return []
        }
        
        let groups = allGroups.filter { group in
            let isLeader = group.leaderID == currentUser.id
            let isMember = group.id.map { id in
                currentUser.groupIDs?.contains(id) ?? false
            } ?? false
            
            return isLeader || isMember
        }
        
        guard !searchText.isEmpty else {
            return groups
        }
        
        let query = searchText.lowercased()
        
        return groups.filter {
            ($0.name ?? "")
                .lowercased()
                .contains(query)
        }
    }
    
    func toggledGroupSelection(
        for memberIDs: [Int],
        in selectedIDs: Set<Int>
    ) -> Set<Int> {
        var newSet = selectedIDs
        let selected = memberIDs.allSatisfy { newSet.contains($0) }
        
        if selected {
            memberIDs.forEach { newSet.remove($0) }
        } else {
            memberIDs.forEach { newSet.insert($0) }
        }
        
        return newSet
    }
}
