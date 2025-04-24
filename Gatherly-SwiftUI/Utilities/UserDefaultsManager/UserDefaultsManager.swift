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
        static let users = "gatherly_users"
        static let events = "gatherly_events"
        static let groups = "gatherly_groups"
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

    // MARK: - Reset

    static func resetAll() {
        removeUsers()
        removeEvents()
        removeGroups()
    }
}
