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
    @Published var syncedContacts: [SyncedContact] = []
    
    init(currentUser: User, allUsers: [User], syncedContacts: [SyncedContact]) {
        self.currentUser = currentUser
        self.allUsers = allUsers
        self.syncedContacts = syncedContacts
        self.didSyncContacts = !syncedContacts.isEmpty
        
        // update once backend implemented
        let contactPhones = Set(syncedContacts.map { $0.phoneNumber })
        self.matchedContacts = allUsers.filter { user in
            guard let phone = user.phone else { return false }
            let cleaned = phone.filter(\.isWholeNumber)
            return contactPhones.contains(cleaned)
        }
    }
    
    func contactName(for user: User) -> String? {
        guard let phone = user.phone?.filter(\.isWholeNumber) else { return nil }
        return syncedContacts.first(where: { $0.phoneNumber == phone })?.fullName
    }
    
    var filteredUsers: [User] {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let usersToSearch = allUsers
        
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
