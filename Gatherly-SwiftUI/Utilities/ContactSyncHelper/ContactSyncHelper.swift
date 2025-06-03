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
        let usersDict = UserDefaultsManager.loadUsers()
        
        let existingPhones = Set(
            usersDict.values.compactMap { user in
                user.phone?.filter(\.isWholeNumber)
            }
        )
        
        let uniqueContacts = contacts.filter {
            !existingPhones.contains($0.phoneNumber.filter(\.isWholeNumber))
        }
        
        var usedIDs = Set(usersDict.keys)
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
        var usersDict = UserDefaultsManager.loadUsers()
        
        let newUsersDict: [Int: User] = Dictionary(uniqueKeysWithValues: newUsers.compactMap { user in
            guard let id = user.id else {
                return nil
            }
            
            return (id, user)
        })
                
        for (id, newUser) in newUsersDict {
            usersDict[id] = newUser
        }
                
        // update currentUser's friend list
        if var currentUser = usersDict[currentUserID] {
            let existingFriends = currentUser.friendIDs ?? []
            let combined = Set(existingFriends + newFriendIDs)
            
            currentUser.friendIDs = Array(combined).sorted()
            usersDict[currentUserID] = currentUser

            UserDefaultsManager.saveCurrentUser(currentUser)
        }
        
        UserDefaultsManager.saveUsers(usersDict)
    }
}
