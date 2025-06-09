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
        searchText: String
    ) -> [UserGroup] {
        guard !searchText.isEmpty else {
            return allGroups
        }
        
        let query = searchText.lowercased()
        
        return allGroups.filter {
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
