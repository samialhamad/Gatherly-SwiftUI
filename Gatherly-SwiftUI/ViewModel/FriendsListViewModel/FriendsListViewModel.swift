//
//  FriendsListViewModel.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/27/25.
//

import Foundation
import SwiftUI

class FriendsListViewModel: ObservableObject {
    private let currentUserID: Int
    private let allUsers: [User]
    
    @Published var searchText: String = ""
    
    //needs to change in future
    init(currentUserID: Int = 1, allUsers: [User] = SampleData.sampleUsers) {
        self.currentUserID = currentUserID
        self.allUsers = allUsers
    }

    var friends: [User] {
        guard let currentUser = allUsers.first(where: { $0.id == currentUserID }),
              let friendIDs = currentUser.friendIDs else {
            return []
        }
        
        return allUsers.filter { friendIDs.contains($0.id ?? 0) }
    }

    var filteredFriends: [User] {
        if searchText.isEmpty {
            return friends
        } else {
            let lowercasedQuery = searchText.lowercased()
            
            return friends.filter { user in
                (user.firstName?.lowercased().contains(lowercasedQuery) ?? false)
                || (user.lastName?.lowercased().contains(lowercasedQuery) ?? false)
            }
        }
    }

    var groupedFriends: [String: [User]] {
        Dictionary(grouping: filteredFriends) { user in
            let firstLetter = user.firstName?.first.map { String($0).uppercased() } ?? ""
            return firstLetter
        }
    }

    var sortedSectionKeys: [String] {
        groupedFriends.keys.sorted()
    }
}
