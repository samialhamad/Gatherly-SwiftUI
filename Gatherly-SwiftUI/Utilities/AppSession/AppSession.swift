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
        if !didSeedSampleData {
            self.users = SampleData.sampleUsers
            self.events = SampleData.sampleEvents
            self.groups = SampleData.sampleGroups
            
            applySampleDataForSami()
            saveAllData()
            didSeedSampleData = true
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
    
    // MARK: - Users
    
    func appendUsersAndUpdateFriends(newUsers: [User], newFriendIDs: [Int], currentUserID: Int) {
        self.users.append(contentsOf: newUsers)
        
        if let index = self.users.firstIndex(where: { $0.id == currentUserID }) {
            let currentUser = self.users[index]
            var friendIDs = currentUser.friendIDs ?? []
            let uniqueNewFriendIDs = newFriendIDs.filter { !friendIDs.contains($0) }
            
            friendIDs.append(contentsOf: uniqueNewFriendIDs)
            currentUser.friendIDs = Array(Set(friendIDs))
        } else {
            let newCurrentUser = User(
                createdTimestamp: Int(Date().timestamp),
                deviceToken: nil,
                email: nil,
                eventIDs: [],
                firstName: "You",
                friendIDs: newFriendIDs,
                groupIDs: [],
                id: currentUserID,
                isEmailEnabled: false,
                lastName: "",
                phone: nil
            )
            self.users.insert(newCurrentUser, at: 0)
        }
        
        UserDefaultsManager.saveUsers(users)
        updateLocalFriendsAndGroups()
        self.currentUser = users.first(where: { $0.id == currentUserID })
    }
    
    func generateUsersFromContacts(_ contacts: [SyncedContact]) async -> ([User], [Int]) {
        let existingPhones = Set(users.compactMap { $0.phone?.filter(\.isWholeNumber) })
        var newUsers: [User] = []
        var newFriendIDs: [Int] = []
        var nextAvailableID = (users.map { $0.id ?? 0 }.max() ?? 999) + 1
        
        for contact in contacts {
            let cleaned = contact.phoneNumber.filter(\.isWholeNumber)
            guard !existingPhones.contains(cleaned) else {
                continue
            }
            
            let user = await GatherlyAPI.createUser(from: contact, id: nextAvailableID)
            newUsers.append(user)
            newFriendIDs.append(nextAvailableID)
            nextAvailableID += 1
        }
        
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
        ContactSyncManager.shared.fetchContacts { contacts in
            Task {
                let (newUsers, newFriendIDs) = await self.generateUsersFromContacts(contacts)
                await MainActor.run {
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
    
    // MARK: - Mock API Requests
    
    func markRequestFinished() {
        pendingRequests -= 1
        if pendingRequests == 0 {
            isLoading = false
        }
    }
    
    func performMockAPILoad() {
        pendingRequests = 0
        isLoading = true
        
        if users.isEmpty {
            pendingRequests += 1
            GatherlyAPI.getUsers()
                .sink { [weak self] fetchedUsers in
                    guard let self = self else { return }
                    self.users = fetchedUsers
                    self.currentUser = fetchedUsers.first(where: { $0.id == 1 })
                    self.updateLocalFriendsAndGroups()
                    UserDefaultsManager.saveUsers(fetchedUsers)
                    self.markRequestFinished()
                }
                .store(in: &cancellables)
        } else {
            markRequestFinished()
        }
        
        if events.isEmpty {
            pendingRequests += 1
            GatherlyAPI.getEvents()
                .sink { [weak self] fetchedEvents in
                    guard let self = self else { return }
                    self.events = fetchedEvents
                    UserDefaultsManager.saveEvents(fetchedEvents)
                    self.markRequestFinished()
                }
                .store(in: &cancellables)
        } else {
            markRequestFinished()
        }
        
        if groups.isEmpty {
            pendingRequests += 1
            GatherlyAPI.getGroups()
                .observe(on: MainScheduler.instance)
                .subscribe(onNext: { [weak self] fetchedGroups in
                    guard let self = self else { return }
                    self.groups = fetchedGroups
                    UserDefaultsManager.saveGroups(fetchedGroups)
                    self.markRequestFinished()
                })
                .disposed(by: disposeBag)
        } else {
            markRequestFinished()
        }
        
        if pendingRequests == 0 {
            isLoading = false
        }
    }
}
