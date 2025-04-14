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

    private var cancellables = Set<AnyCancellable>()

    func loadAllData() {
        GatherlyAPI.getUsers()
            .sink { [weak self] fetchedUsers in
                self?.users = fetchedUsers

                ContactSyncManager.shared.fetchContacts { contacts in
                    let existingPhones = Set(fetchedUsers.compactMap { $0.phone?.filter(\.isWholeNumber) })

                    let newUsers: [User] = contacts.enumerated().compactMap { index, contact in
                        let cleaned = contact.phoneNumber.filter(\.isWholeNumber)
                        guard !existingPhones.contains(cleaned) else { return nil }
                        return User(from: contact, id: 1000 + index)
                    }

                    self?.users.append(contentsOf: newUsers)
                }
            }
            .store(in: &cancellables)

        GatherlyAPI.getEvents()
            .sink { [weak self] in
                self?.events = $0
            }
            .store(in: &cancellables)

        GatherlyAPI.getGroups()
            .sink { [weak self] in
                self?.groups = $0
            }
            .store(in: &cancellables)
    }
}
