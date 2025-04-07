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
    @Published var allUsers: [User]
    @Published var currentUser: User
    @Published var matchedContacts: [User] = []
    @Published var didSyncContacts = false
    
    init(currentUser: User, allUsers: [User]) {
        self.currentUser = currentUser
        self.allUsers = allUsers
    }
    
    // MARK: - Sync Contacts
    func syncContacts() {
        ContactSyncManager.shared.fetchContactsPhoneNumbers { contactNumbers in
            self.matchedContacts = self.allUsers.filter { user in
                guard let phone = user.phone else { return false }
                let cleaned = phone.filter(\.isWholeNumber)
                return contactNumbers.contains(cleaned)
            }
            self.didSyncContacts = true
        }
    }
    
    // MARK: - Filtered Results

    var filteredUsers: [User] {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let usersToSearch = didSyncContacts ? matchedContacts : allUsers
        
        return usersToSearch.filter { user in
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
