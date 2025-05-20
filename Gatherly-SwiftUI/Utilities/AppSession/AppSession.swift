//
//  AppSession.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 5/12/25.
//

import Combine
import Foundation
import SwiftUI
import RxSwift

final class AppSession: ObservableObject {
    @Published var currentUser: User? = nil
    @AppStorage("didSeedSampleData") private var didSeedSampleData = false
    @AppStorage("didSyncContacts") var didSyncContacts = false
    @Published var events: [Event] = []
    @Published var friends: [User] = []
    @Published var friendsDict: [Int: User] = [:]
    @Published var groups: [UserGroup] = []
    @Published var isLoading: Bool = true
    @Published var navigationState = NavigationState()
    @Published var users: [User] = []
    @Published var userGroups: [UserGroup] = []
    
    private var cancellables = Set<AnyCancellable>()
    private var disposeBag = DisposeBag()
    private var pendingRequests = 0
    
    
    // MARK: - Data
    
    private func applySampleDataForSami() {
        guard let samiIndex = users.firstIndex(where: { $0.id == 1 }) else {
            return
        }
        
        let sami = users[samiIndex]
        
        sami.eventIDs = events
            .filter { $0.plannerID == 1 || ($0.memberIDs?.contains(1) ?? false) }
            .compactMap { $0.id }
        
        sami.groupIDs = groups
            .filter { $0.leaderID == 1 || ($0.memberIDs.contains(1)) }
            .compactMap { $0.id }
        
        sami.friendIDs = [2, 3, 4]
        users[samiIndex] = sami
    }
    
    func loadAllData() {
        // for UI tests to reset UserDefaults
        if CommandLine.arguments.contains("--uitesting") {
            print("UI Testing: Resetting UserDefaults and loading SampleData")
            UserDefaultsManager.resetAll()
            seedAndApplySampleData()
            return
        }
        
        if !didSeedSampleData {
            seedAndApplySampleData()
        } else {
            self.users = UserDefaultsManager.loadUsers()
            self.events = UserDefaultsManager.loadEvents()
            self.groups = UserDefaultsManager.loadGroups()
        }
        
        self.currentUser = users.first(where: { $0.id == 1 })
        updateLocalFriendsAndGroups()
        self.isLoading = false
    }
    
    func saveAllData() {
        UserDefaultsManager.saveUsers(users)
        UserDefaultsManager.saveEvents(events)
        UserDefaultsManager.saveGroups(groups)
    }
    
    private func seedAndApplySampleData() {
        self.users = SampleData.sampleUsers
        self.events = SampleData.sampleEvents
        self.groups = SampleData.sampleGroups
        
        applySampleDataForSami()
        saveAllData()
        didSeedSampleData = true
        
        self.currentUser = users.first(where: { $0.id == 1 })
        updateLocalFriendsAndGroups()
        self.isLoading = false
    }
    
    // MARK: - Users
    
    func appendUsersAndUpdateFriends(newUsers: [User], newFriendIDs: [Int], currentUserID: Int) {
        self.users.append(contentsOf: newUsers)
        
        if let index = self.users.firstIndex(where: { $0.id == currentUserID }) {
            let oldCurrentUser = self.users[index]
            var friendIDs = oldCurrentUser.friendIDs ?? []
            let uniqueNewFriendIDs = newFriendIDs.filter { !friendIDs.contains($0) }

            friendIDs.append(contentsOf: uniqueNewFriendIDs)
            let updatedUser = User(
                avatarImageName: oldCurrentUser.avatarImageName,
                bannerImageName: oldCurrentUser.bannerImageName,
                createdTimestamp: oldCurrentUser.createdTimestamp,
                deviceToken: oldCurrentUser.deviceToken,
                email: oldCurrentUser.email,
                eventIDs: oldCurrentUser.eventIDs,
                firstName: oldCurrentUser.firstName,
                friendIDs: Array(Set(friendIDs)),
                groupIDs: oldCurrentUser.groupIDs,
                id: oldCurrentUser.id,
                isEmailEnabled: oldCurrentUser.isEmailEnabled,
                lastName: oldCurrentUser.lastName,
                phone: oldCurrentUser.phone
            )
            self.users[index] = updatedUser
            self.currentUser = updatedUser
        }
        
        UserDefaultsManager.saveUsers(self.users)
        updateLocalFriendsAndGroups()
        self.currentUser = users.first(where: { $0.id == currentUserID })
    }
    
    func generateUsersFromContacts(_ contacts: [SyncedContact]) async -> ([User], [Int]) {
        let existingPhoneNumbers = Set(users.compactMap { $0.phone?.filter(\.isWholeNumber) })
        var newUsers: [User] = []
        var newFriendIDs: [Int] = []
        var nextAvailableID = (users.map { $0.id ?? 0 }.max() ?? 999) + 1
        
        // Filter out duplicates
        let uniqueContacts = contacts.filter { contact in
            let cleaned = contact.phoneNumber.filter(\.isWholeNumber)
            return !existingPhoneNumbers.contains(cleaned)
        }
        
        // Assign ID to every new contact
        let contactIDPairs = uniqueContacts.map { contact in
            let assignedID = nextAvailableID
            nextAvailableID += 1
            return (contact, assignedID)
        }
        
        // Parallel (task group ) creation of users
        let results = await withTaskGroup(of: (User).self) { group in
            for (contact, id) in contactIDPairs {
                group.addTask {
                    return await GatherlyAPI.createUser(from: contact, id: id)
                }
            }
            
            var collectedUsers: [User] = []
            
            for await user in group {
                collectedUsers.append(user)
            }
            
            return collectedUsers
        }
        
        newUsers = results
        newFriendIDs = results.compactMap { $0.id }
        
        return (newUsers, newFriendIDs)
    }
    
    func updateLocalFriendsAndGroups() {
        guard let currentUser else {
            return
        }
        
        self.friendsDict = Dictionary(
            uniqueKeysWithValues: (currentUser.friendIDs ?? []).compactMap { id in
                users.first(where: { $0.id == id }).map { ($0.id!, $0) }
            }
        )
        
        self.friends = currentUser.resolvedFriends(from: self.friendsDict)
        
        self.userGroups = groups.filter { group in
            group.leaderID == currentUser.id ||
            (group.id != nil && currentUser.groupIDs?.contains(group.id!) == true)
        }
    }
    
    func syncContacts(currentUserID: Int = 1) {
        isLoading = true
        ContactSyncManager.shared.fetchContacts { [weak self] contacts in
            guard let self else {
                return
            }
            
            Task { [weak self] in
                guard let self else {
                    return
                }
                
                let (newUsers, newFriendIDs) = await self.generateUsersFromContacts(contacts)
                
                await MainActor.run { [weak self] in
                    guard let self else {
                        return
                    }
                    self.appendUsersAndUpdateFriends(
                        newUsers: newUsers,
                        newFriendIDs: newFriendIDs,
                        currentUserID: currentUserID
                    )
                    self.isLoading = false
                }
            }
        }
    }
}
