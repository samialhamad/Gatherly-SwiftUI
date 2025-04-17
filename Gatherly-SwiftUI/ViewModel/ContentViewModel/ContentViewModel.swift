//
//  ContentViewModel.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 4/14/25.
//

import Combine
import Foundation
import SwiftUI

final class ContentViewModel: ObservableObject {
    @Published var currentUser: User? = nil
    @Published var users: [User] = []
    @Published var events: [Event] = []
    @Published var groups: [UserGroup] = []
    @Published var isLoading = true
    
    private var cancellables = Set<AnyCancellable>()
    private var pendingRequests = 0
    
    func loadAllData() {
        isLoading = true
        pendingRequests = 0 // no API for now

        self.users = UserDefaultsManager.loadUsers()
        self.events = UserDefaultsManager.loadEvents()
        self.groups = UserDefaultsManager.loadGroups()

        // fallback to sample data on first launch
        if users.isEmpty {
            self.users = SampleData.sampleUsers
        }
        if events.isEmpty {
            self.events = SampleData.sampleEvents
        }
        if groups.isEmpty {
            self.groups = SampleData.sampleGroups
        }
        
        self.currentUser = users.first(where: { $0.id == 1 })
        isLoading = false
    }

    func saveAllData() {
        UserDefaultsManager.saveUsers(users)
        UserDefaultsManager.saveEvents(events)
        UserDefaultsManager.saveGroups(groups)
    }
    
    private func markRequestFinished() {
        pendingRequests -= 1
        if pendingRequests == 0 {
            isLoading = false
        }
    }
}
