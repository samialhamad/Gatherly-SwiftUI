//
//  ContentViewModel.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 4/14/25.
//

import Combine
import Foundation
import RxSwift
import SwiftUI

final class ContentViewModel: ObservableObject {
    @Published var currentUser: User? = nil
    @Published private(set) var didLoadData = false
    @AppStorage("didSeedSampleData") private var didSeedSampleData = false
    @Published var events: [Event] = []
    @Published var groups: [UserGroup] = []
    @Published var isLoading = true
    @Published var users: [User] = []
    
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
                // First time launch – seed sample data
                self.users = SampleData.sampleUsers
                self.events = SampleData.sampleEvents
                self.groups = SampleData.sampleGroups
                applySampleDataForSami()
                saveAllData()
                didSeedSampleData = true
            } else {
                // Use persisted data
                self.users = UserDefaultsManager.loadUsers()
                self.events = UserDefaultsManager.loadEvents()
                self.groups = UserDefaultsManager.loadGroups()
            }

            self.currentUser = users.first(where: { $0.id == 1 })
            self.isLoading = false
    }
    
    func saveAllData() {
        UserDefaultsManager.saveUsers(users)
        UserDefaultsManager.saveEvents(events)
        UserDefaultsManager.saveGroups(groups)
    }
    
    // MARK: - Contacts & Users
    
    func appendUsersAndUpdateFriends(newUsers: [User], newFriendIDs: [Int], currentUserID: Int) {
        self.users.append(contentsOf: newUsers)
        
        if let currentIndex = self.users.firstIndex(where: { $0.id == currentUserID }) {
            let currentUser = self.users[currentIndex]
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
        
        UserDefaultsManager.saveUsers(self.users)
    }
    
    func generateUsersFromContacts(_ contacts: [SyncedContact]) -> ([User], [Int]) {
        var existingPhones = Set(self.users.compactMap { $0.phone?.filter(\.isWholeNumber) })
        var newUsers: [User] = []
        var newFriendIDs: [Int] = []
        var nextAvailableID = (self.users.map { $0.id ?? 0 }.max() ?? 999) + 1
        
        for contact in contacts {
            let cleaned = contact.phoneNumber.filter(\.isWholeNumber)
            guard !existingPhones.contains(cleaned) else {
                continue
            }
            
            let newUser = User(from: contact, id: nextAvailableID)
            newUsers.append(newUser)
            newFriendIDs.append(nextAvailableID)
            existingPhones.insert(cleaned)
            nextAvailableID += 1
        }
        
        return (newUsers, newFriendIDs)
    }
    
    func syncContacts(currentUserID: Int = 1) {
        ContactSyncManager.shared.fetchContacts { contacts in
            let (newUsers, newFriendIDs) = self.generateUsersFromContacts(contacts)
            
            self.appendUsersAndUpdateFriends(
                newUsers: newUsers,
                newFriendIDs: newFriendIDs,
                currentUserID: currentUserID
            )
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
