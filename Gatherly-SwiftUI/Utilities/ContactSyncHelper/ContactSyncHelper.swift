//
//  ContactSyncHelper.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 5/22/25.
//

import Foundation

enum ContactSyncHelper {
    static func runIfNeeded(currentUserID: Int = 1) async {
        guard !UserDefaultsManager.getDidSyncContacts() else {
            return
        }

        let contacts = await withCheckedContinuation { continuation in
            ContactSyncManager.shared.fetchContacts { contacts in
                continuation.resume(returning: contacts)
            }
        }

        let (newUsers, newFriendIDs) = await generateUsersFromContacts(contacts)
        appendUsersAndUpdateFriends(newUsers, newFriendIDs, currentUserID: currentUserID)
        UserDefaultsManager.setDidSyncContacts(true)
    }
    
    static func forceSync(currentUserID: Int = 1, completion: @escaping () -> Void = {}) {
        ContactSyncManager.shared.fetchContacts { contacts in
            Task {
                let (newUsers, newFriendIDs) = await generateUsersFromContacts(contacts)
                
                appendUsersAndUpdateFriends(newUsers, newFriendIDs, currentUserID: currentUserID)
                UserDefaultsManager.setDidSyncContacts(true)
                
                DispatchQueue.main.async {
                    completion()
                }
            }
        }
    }
    
    private static func generateUsersFromContacts(_ contacts: [SyncedContact]) async -> ([User], [Int]) {
        var users = UserDefaultsManager.loadUsers()
        
        let existingPhones = Set(users.compactMap { $0.phone?.filter(\.isWholeNumber) })
        let uniqueContacts = contacts.filter { !existingPhones.contains($0.phoneNumber.filter(\.isWholeNumber)) }
        
        var usedIDs = Set(users.compactMap { $0.id })
        var nextID = (usedIDs.max() ?? 999) + 1
        
        let results = await withTaskGroup(of: User.self) { group in
            for contact in uniqueContacts {
                
                while usedIDs.contains(nextID) {
                    nextID += 1
                }
                
                let assignedID = nextID
                usedIDs.insert(assignedID)
                nextID += 1
                                
                group.addTask {
                    await GatherlyAPI.createUser(from: contact, id: assignedID)
                }
            }
            return await group.reduce(into: []) { $0.append($1) }
        }
        
        return (results, results.compactMap { $0.id })
    }
    
    private static func appendUsersAndUpdateFriends(_ newUsers: [User], _ newFriendIDs: [Int], currentUserID: Int) {
        var users = UserDefaultsManager.loadUsers()
        
        // convert existing and new users to dictionaries keyed by ID
        var usersDict: [Int: User] = Dictionary(uniqueKeysWithValues: users.compactMap { user in
            guard let id = user.id else {
                return nil
            }
            return (id, user)
        })
        
        let newUsersDict: [Int: User] = Dictionary(uniqueKeysWithValues: newUsers.compactMap { user in
            guard let id = user.id else {
                return nil
            }
            
            return (id, user)
        })
                
        for (id, newUser) in newUsersDict {
            usersDict[id] = newUser
        }
        
        users = Array(usersDict.values).sorted(by: { ($0.id ?? 0) < ($1.id ?? 0) })
        
        // update currentUser's friend list
        if let index = users.firstIndex(where: { $0.id == currentUserID }) {
            var currentUser = users[index]
            let updatedIDs = Set((currentUser.friendIDs ?? []) + newFriendIDs)
            currentUser.friendIDs = Array(updatedIDs).sorted()
            users[index] = currentUser
            
            UserDefaultsManager.saveCurrentUser(currentUser)
        }
        
        UserDefaultsManager.saveUsers(users)
    }
}
