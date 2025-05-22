//
//  ContactSyncHelper.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 5/22/25.
//

import Foundation

enum ContactSyncHelper {
    static func runIfNeeded(currentUserID: Int = 1) {
        guard !UserDefaultsManager.getDidSyncContacts() else {
            return
        }

        ContactSyncManager.shared.fetchContacts { contacts in
            Task {
                let (newUsers, newFriendIDs) = await generateUsersFromContacts(contacts)
                appendUsersAndUpdateFriends(newUsers, newFriendIDs, currentUserID: currentUserID)
                UserDefaultsManager.setDidSyncContacts(true)
            }
        }
    }

    private static func generateUsersFromContacts(_ contacts: [SyncedContact]) async -> ([User], [Int]) {
        let users = UserDefaultsManager.loadUsers()
        let existingPhones = Set(users.compactMap { $0.phone?.filter(\.isWholeNumber) })
        let uniqueContacts = contacts.filter { !existingPhones.contains($0.phoneNumber.filter(\.isWholeNumber)) }

        var nextID = (users.map { $0.id ?? 0 }.max() ?? 999) + 1
        let results = await withTaskGroup(of: User.self) { group in
            for contact in uniqueContacts {
                let assignedID = nextID
                nextID += 1
                group.addTask { await GatherlyAPI.createUser(from: contact, id: assignedID) }
            }
            return await group.reduce(into: []) { $0.append($1) }
        }

        return (results, results.compactMap { $0.id })
    }

    private static func appendUsersAndUpdateFriends(_ newUsers: [User], _ newFriendIDs: [Int], currentUserID: Int) {
        var users = UserDefaultsManager.loadUsers()
        users.append(contentsOf: newUsers)

        if let index = users.firstIndex(where: { $0.id == currentUserID }) {
            var currentUser = users[index]
            let updatedIDs = Set((currentUser.friendIDs ?? []) + newFriendIDs)
            currentUser.friendIDs = Array(updatedIDs).sorted()
            users[index] = currentUser
        }

        UserDefaultsManager.saveUsers(users)
    }
}
