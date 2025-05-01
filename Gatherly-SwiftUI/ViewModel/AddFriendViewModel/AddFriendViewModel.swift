//
//  AddFriendViewModel.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/31/25.
//

import Foundation
import SwiftUI
import Contacts

class AddFriendViewModel: ObservableObject {
    @Published var searchText: String = ""

    let currentUserID: Int
    let allUsers: [User]
    
    var currentUser: User? {
        allUsers.first(where: { $0.id == currentUserID })
    }
    
    init(currentUserID: Int, allUsers: [User]) {
        self.currentUserID = currentUserID
        self.allUsers = allUsers
    }
    
    var filteredUsers: [User] {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let usersToSearch = allUsers
        
        return usersToSearch.filter { user in
            guard let currentUser = currentUser else {
                return false
            }

            let isNotSelf = user.id != currentUser.id
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
