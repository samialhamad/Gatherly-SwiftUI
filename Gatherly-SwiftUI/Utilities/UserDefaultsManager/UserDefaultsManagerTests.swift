//
//  UserDefaultsManagerTests.swift
//  Gatherly-SwiftUITests
//
//  Created by Sami Alhamad on 4/17/25.
//

import XCTest
@testable import Gatherly_SwiftUI

final class UserDefaultsManagerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        UserDefaultsManager.resetAll()
    }
    
    override func tearDown() {
        UserDefaultsManager.resetAll()
        super.tearDown()
    }
    
    func testSaveAndLoadUsers() {
        let sampleUsers = [
            User(firstName: "Alice", id: 1),
            User(firstName: "Bob", id: 2)
        ]
        
        let sampleUsersDict = sampleUsers.keyedBy(\.id)
        
        UserDefaultsManager.saveUsers(sampleUsersDict)
        let loadedUsersDict = UserDefaultsManager.loadUsers()
        
        XCTAssertEqual(sampleUsersDict, loadedUsersDict)
    }
    
    func testSaveAndLoadEvents() {
        let sampleEvents = [
            Event(id: 1, title: "One"),
            Event(id: 2, title: "Two")
        ]
        
        let sampleEventsDict = sampleEvents.keyedBy(\.id)
        
        UserDefaultsManager.saveEvents(sampleEventsDict)
        let loadedEventsDict = UserDefaultsManager.loadEvents()
        
        XCTAssertEqual(sampleEventsDict, loadedEventsDict)
    }
    
    func testSaveAndLoadGroups() {
        let sampleGroups = [
            UserGroup(id: 1, leaderID: 1, memberIDs: [1, 2], name: "One"),
            UserGroup(id: 2, leaderID: 2, memberIDs: [2, 3], name: "Two")
        ]
        
        let sampleGroupsDict = sampleGroups.keyedBy(\.id)
        
        UserDefaultsManager.saveGroups(sampleGroupsDict)
        let loadedGroupsDict = UserDefaultsManager.loadGroups()
        
        XCTAssertEqual(loadedGroupsDict, sampleGroupsDict)
    }
    
    func testResetAllClearsData() {
        let dummyUser   = User(id: 1)
        let dummyEvent  = Event(id: 1)
        let dummyGroup  = UserGroup(id: 1, leaderID: 1, memberIDs: [1], name: "Group")
        
        UserDefaultsManager.saveUsers([1: dummyUser])
        UserDefaultsManager.saveEvents([1: dummyEvent])
        UserDefaultsManager.saveGroups([1: dummyGroup])
        
        UserDefaultsManager.resetAll()
        
        XCTAssertTrue(UserDefaultsManager.loadUsers().isEmpty)
        XCTAssertTrue(UserDefaultsManager.loadEvents().isEmpty)
        XCTAssertTrue(UserDefaultsManager.loadGroups().isEmpty)
        
        XCTAssertFalse(UserDefaultsManager.getDidSeedSampleData())
        XCTAssertFalse(UserDefaultsManager.getDidSyncContacts())
        XCTAssertNil(UserDefaultsManager.loadCurrentUser())
    }
}
