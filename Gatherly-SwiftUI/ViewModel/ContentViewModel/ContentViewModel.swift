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
    @AppStorage("didSyncContacts") private var didSyncContacts = false
    @Published var currentUser: User? = nil
    @Published var users: [User] = []
    @Published var events: [Event] = []
    @Published var groups: [UserGroup] = []
    @Published var isLoading = true
    
    private var cancellables = Set<AnyCancellable>()
    private var disposeBag = DisposeBag()
    private var pendingRequests = 0
    
    func loadAllData() {
        self.users = UserDefaultsManager.loadUsers()
        self.events = UserDefaultsManager.loadEvents()
        self.groups = UserDefaultsManager.loadGroups()
        self.currentUser = users.first(where: { $0.id == 1 })
        
        performMockAPILoad()
    }
    
    func saveAllData() {
        UserDefaultsManager.saveUsers(users)
        UserDefaultsManager.saveEvents(events)
        UserDefaultsManager.saveGroups(groups)
    }
    
    func syncContacts(currentUserID: Int = 1) {
        guard !didSyncContacts else { return }
        
        ContactSyncManager.shared.fetchContacts { contacts in
            let (newUsers, newFriendIDs) = self.generateUsersFromContacts(contacts)
            self.appendUsersAndUpdateFriends(newUsers: newUsers, newFriendIDs: newFriendIDs, currentUserID: currentUserID)
        }
    }
    
    // MARK: - Helper Functions
    
    private func appendUsersAndUpdateFriends(newUsers: [User], newFriendIDs: [Int], currentUserID: Int) {
        self.users.append(contentsOf: newUsers)
        
        if let currentIndex = self.users.firstIndex(where: { $0.id == currentUserID }) {
            var currentUser = self.users[currentIndex]
            var friendIDs = currentUser.friendIDs ?? []
            
            let uniqueNewFriendIDs = newFriendIDs.filter { !friendIDs.contains($0) }
            friendIDs.append(contentsOf: uniqueNewFriendIDs)
            
            currentUser.friendIDs = Array(Set(friendIDs))
            self.users[currentIndex] = currentUser
        } else {
            let newCurrentUser = User(
                createdTimestamp: Int(Date().timestamp),
                deviceToken: nil,
                email: nil,
                eventIDs: [],
                firstName: "You",
                friendIDs: newFriendIDs,
                id: currentUserID,
                isEmailEnabled: false,
                lastName: "",
                phone: nil
            )
            self.users.insert(newCurrentUser, at: 0)
        }
        
        UserDefaultsManager.saveUsers(self.users)
        self.didSyncContacts = true
    }
    
    
    private func generateUsersFromContacts(_ contacts: [SyncedContact]) -> ([User], [Int]) {
        var existingPhones = Set(self.users.compactMap { $0.phone?.filter(\.isWholeNumber) })
        var newUsers: [User] = []
        var newFriendIDs: [Int] = []
        var nextAvailableID = (self.users.map { $0.id ?? 0 }.max() ?? 999) + 1
        
        for contact in contacts {
            let cleaned = contact.phoneNumber.filter(\.isWholeNumber)
            guard !existingPhones.contains(cleaned) else { continue }
            
            let newUser = User(from: contact, id: nextAvailableID)
            newUsers.append(newUser)
            newFriendIDs.append(nextAvailableID)
            existingPhones.insert(cleaned)
            nextAvailableID += 1
        }
        
        return (newUsers, newFriendIDs)
    }
    
    private func markRequestFinished() {
        pendingRequests -= 1
        if pendingRequests == 0 {
            isLoading = false
        }
    }
    
    private func performMockAPILoad() {
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
        }

        // If everything was already loaded from UserDefaults
        if pendingRequests == 0 {
            isLoading = false
        }
    }

}
