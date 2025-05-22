//
//  UserDefaultsManager.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 4/15/25.
//

import Foundation

enum UserDefaultsManager {
    
    // MARK: - Keys
    
    private enum Keys {
        static let didSeedSampleData = "gatherly_didSeedSampleData"
        static let didSyncContacts = "gatherly_didSyncContacts"
        static let events = "gatherly_events"
        static let groups = "gatherly_groups"
        static let users = "gatherly_users"
    }
    
    private static let defaults = UserDefaults.standard

    // MARK: - Users

    static func saveUsers(_ users: [User]) {
        defaults.setCodable(users, forKey: Keys.users)
    }

    static func loadUsers() -> [User] {
        defaults.getCodable(forKey: Keys.users, type: [User].self) ?? []
    }

    static func removeUsers() {
        defaults.removeObject(forKey: Keys.users)
    }

    // MARK: - Events

    static func saveEvents(_ events: [Event]) {
        defaults.setCodable(events, forKey: Keys.events)
    }

    static func loadEvents() -> [Event] {
        defaults.getCodable(forKey: Keys.events, type: [Event].self) ?? []
    }

    static func removeEvents() {
        defaults.removeObject(forKey: Keys.events)
    }

    // MARK: - Groups

    static func saveGroups(_ groups: [UserGroup]) {
        defaults.setCodable(groups, forKey: Keys.groups)
    }

    static func loadGroups() -> [UserGroup] {
        defaults.getCodable(forKey: Keys.groups, type: [UserGroup].self) ?? []
    }

    static func removeGroups() {
        defaults.removeObject(forKey: Keys.groups)
    }
    
    // MARK: - Flags

    static func setDidSeedSampleData(_ value: Bool) {
        defaults.set(value, forKey: Keys.didSeedSampleData)
    }

    static func getDidSeedSampleData() -> Bool {
        defaults.bool(forKey: Keys.didSeedSampleData)
    }

    static func setDidSyncContacts(_ value: Bool) {
        defaults.set(value, forKey: Keys.didSyncContacts)
    }

    static func getDidSyncContacts() -> Bool {
        defaults.bool(forKey: Keys.didSyncContacts)
    }

    static func resetFlags() {
        defaults.removeObject(forKey: Keys.didSeedSampleData)
        defaults.removeObject(forKey: Keys.didSyncContacts)
    }

    // MARK: - Reset

    static func resetAll() {
        removeUsers()
        removeEvents()
        removeGroups()
        resetFlags()
    }
}
