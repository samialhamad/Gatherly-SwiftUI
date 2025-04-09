//
//  FriendsViewModel.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 4/9/25.
//

import Foundation
import Contacts

class FriendsViewModel: ObservableObject {
    @Published var syncedContacts: [SyncedContact] = []
    @Published var didSyncContacts = false

    func syncContactsIfNeeded() {
        guard !didSyncContacts else { return }

        ContactSyncManager.shared.fetchContacts { contacts in
            self.syncedContacts = contacts
            self.didSyncContacts = true
        }
    }
}
