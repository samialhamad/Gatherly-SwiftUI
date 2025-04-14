//
//  ContentViewModel.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 4/14/25.
//

import Foundation
import Combine

final class ContentViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var events: [Event] = []
    @Published var groups: [UserGroup] = []
    @Published var isLoading = true
    
    private var cancellables = Set<AnyCancellable>()
    private var pendingRequests = 0
    
    func loadAllData() {
        isLoading = true
        pendingRequests = 3
        
        GatherlyAPI.getUsers()
            .sink { [weak self] fetchedUsers in
                guard let self = self else {
                    return
                }
                self.users = fetchedUsers
                
                ContactSyncManager.shared.fetchContacts { contacts in
                    let existingPhones = Set(fetchedUsers.compactMap { $0.phone?.filter(\.isWholeNumber) })
                    
                    let newUsers: [User] = contacts.enumerated().compactMap { index, contact in
                        let cleaned = contact.phoneNumber.filter(\.isWholeNumber)
                        guard !existingPhones.contains(cleaned) else { return nil }
                        return User(from: contact, id: 1000 + index)
                    }
                    
                    self.users.append(contentsOf: newUsers)
                    self.markRequestFinished()
                }
            }
            .store(in: &cancellables)
        
        GatherlyAPI.getEvents()
            .sink { [weak self] events in
                self?.events = events
                self?.markRequestFinished()
            }
            .store(in: &cancellables)
        
        GatherlyAPI.getGroups()
            .sink { [weak self] groups in
                self?.groups = groups
                self?.markRequestFinished()
            }
            .store(in: &cancellables)
    }
    
    private func markRequestFinished() {
        pendingRequests -= 1
        if pendingRequests == 0 {
            isLoading = false
        }
    }
}
