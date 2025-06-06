//
//  ContactSyncHelper.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 5/22/25.
//

import Foundation

enum ContactSyncHelper {
    static func runIfNeeded(currentUserID: Int = SampleData.currentUserID) async {
        guard !UserDefaultsManager.getDidSyncContacts() else {
            return
        }

        let contacts = await withCheckedContinuation { continuation in
            ContactSyncManager.shared.fetchContacts { contacts in
                continuation.resume(returning: contacts)
            }
        }

        await mergeContactsIntoFriends(contacts, currentUserID: currentUserID)
    }
    
    static func forceSync(currentUserID: Int = SampleData.currentUserID, completion: @escaping () -> Void = {}) {
        ContactSyncManager.shared.fetchContacts { contacts in
            Task {
                await mergeContactsIntoFriends(contacts, currentUserID: currentUserID)
                
                DispatchQueue.main.async {
                    completion()
                }
            }
        }
    }
    
    private static func mergeContactsIntoFriends(_ contacts: [SyncedContact], currentUserID: Int) async {
        let newUsers = await generateUsersFromContacts(contacts)
        let newFriendIDs = newUsers.compactMap { $0.id }
        
        appendUsersAndUpdateFriends(
            newUsers: newUsers,
            newFriendIDs: newFriendIDs,
            currentUserID: currentUserID
        )
        
        UserDefaultsManager.setDidSyncContacts(true)
    }
    
    private static func generateUsersFromContacts(_ contacts: [SyncedContact]) async -> [User] {
        let usersDict = UserDefaultsManager.loadUsers()
        
        let existingPhones = Set(
            usersDict.values.compactMap { user in
                user.phone?.filter(\.isWholeNumber)
            }
        )
        
        let newContacts = contacts.filter {
            !existingPhones.contains($0.phoneNumber.filter(\.isWholeNumber))
        }
        
        var usedIDs = Set(usersDict.keys)
        var nextID = (usedIDs.max() ?? 999) + 1
        
        let results = await withTaskGroup(of: User.self) { group in
            for contact in newContacts {
                
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
        
        return results
    }
    
    private static func appendUsersAndUpdateFriends(newUsers: [User], newFriendIDs: [Int], currentUserID: Int) {
        var usersDict = UserDefaultsManager.loadUsers()
        
        let newUsersDict = newUsers.keyedBy(\.id)
                
        for (id, newUser) in newUsersDict {
            usersDict[id] = newUser
        }
                
        // update currentUser's friend list
        if var currentUser = UserDefaultsManager.loadCurrentUser() {
            let existingFriends = currentUser.friendIDs ?? []
            let combinedFriends = Set(existingFriends + newFriendIDs)
            
            currentUser.friendIDs = Array(combinedFriends).sorted()
            usersDict[currentUserID] = currentUser

            UserDefaultsManager.saveCurrentUser(currentUser)
        }
        
        UserDefaultsManager.saveUsers(usersDict)
    }
}
