//
//  AddFriendViewModel.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/31/25.
//

import Foundation
import SwiftUI

class AddFriendViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var allUsers: [User]
    @Published var currentUser: User
    
    init(currentUser: User, allUsers: [User]) {
        self.currentUser = currentUser
        self.allUsers = allUsers
    }
    
    var filteredUsers: [User] {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        return allUsers.filter { user in
            guard let currentID = currentUser.id else { return false }
            
            let isNotSelf = user.id != currentID
            let isNotAlreadyFriend = !(currentUser.friendIDs ?? []).contains(user.id ?? -1)
            
            let firstNameMatches = user.firstName?.lowercased().contains(query) ?? false
            let lastNameMatches = user.lastName?.lowercased().contains(query) ?? false
            
            let matchesSearch = !query.isEmpty && (firstNameMatches || lastNameMatches)
            
            return isNotSelf && isNotAlreadyFriend && matchesSearch
        }
    }
    
    //placeholder
    func sendFriendRequest(to user: User) {
        print("Sending friend request to \(user.firstName ?? "Unknown")")
    }
}
