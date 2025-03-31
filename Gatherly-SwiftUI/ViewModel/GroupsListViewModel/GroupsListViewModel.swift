//
//  GroupsListViewModel.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/30/25.
//

import Foundation

class GroupsViewModel: ObservableObject {
    private var currentUser: User = SampleData.sampleUsers.first { $0.id == 1 }! // replace in future, right now hard coded to user id 1
    
    @Published var searchText: String = ""
    
    // also needs to be revisited once sampleData is done away with
    var allGroups: [UserGroup] {
           guard let userGroupIDs = currentUser.groupIDs else { return [] }
           return SampleData.sampleGroups.filter { userGroupIDs.contains($0.id) }
       }
    
    var filteredGroups: [UserGroup] {
        if searchText.isEmpty {
            return allGroups
        } else {
            let lowercasedQuery = searchText.lowercased()
            return allGroups.filter {
                $0.name.lowercased().contains(lowercasedQuery)
            }
        }
    }
}
