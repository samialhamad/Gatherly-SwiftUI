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
        static let didSeedSampleData = "didSeedSampleData"
        static let didSyncContacts = "didSyncContacts"
        static let currentUser = "currentUser"
        static let events = "events"
        static let groups = "groups"
        static let users = "users"
    }
    
    private static let defaults = UserDefaults.standard
    
    // MARK: - Current User
    
    static func saveCurrentUser(_ user: User) {
        defaults.setCodable(user, forKey: Keys.currentUser)
    }
    
    static func loadCurrentUser() -> User? {
        defaults.getCodable(forKey: Keys.currentUser, type: User.self)
    }
    
    static func removeCurrentUser() {
        defaults.removeObject(forKey: Keys.currentUser)
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
        removeCurrentUser()
        removeEvents()
        removeGroups()
        removeUsers()
        resetFlags()
    }
}
