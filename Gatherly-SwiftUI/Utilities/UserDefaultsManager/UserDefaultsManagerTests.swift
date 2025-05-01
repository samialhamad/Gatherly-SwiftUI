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
        
        UserDefaultsManager.saveUsers(sampleUsers)
        let loadedUsers = UserDefaultsManager.loadUsers()
        
        XCTAssertEqual(loadedUsers, sampleUsers)
    }
    
    func testSaveAndLoadEvents() {
        let sampleEvents = [
            Event(date: Date(), id: 1, title: "Lunch"),
            Event(date: Date(), id: 2, title: "Meeting")
        ]
        
        UserDefaultsManager.saveEvents(sampleEvents)
        let loadedEvents = UserDefaultsManager.loadEvents()
        
        XCTAssertEqual(loadedEvents, sampleEvents)
    }
    
    func testSaveAndLoadGroups() {
        let sampleGroups = [
            UserGroup(id: 1, leaderID: 1, memberIDs: [1, 2], name: "Team"),
            UserGroup(id: 2, leaderID: 2, memberIDs: [2, 3], name: "Friends")
        ]
        
        UserDefaultsManager.saveGroups(sampleGroups)
        let loadedGroups = UserDefaultsManager.loadGroups()
        
        XCTAssertEqual(loadedGroups, sampleGroups)
    }
    
    func testResetAllClearsData() {
        UserDefaultsManager.saveUsers([User(id: 1)])
        UserDefaultsManager.saveEvents([Event(id: 1)])
        UserDefaultsManager.saveGroups([UserGroup(id: 1, leaderID: 1, memberIDs: [1], name: "Group")])
        
        UserDefaultsManager.resetAll()
        
        XCTAssertTrue(UserDefaultsManager.loadUsers().isEmpty)
        XCTAssertTrue(UserDefaultsManager.loadEvents().isEmpty)
        XCTAssertTrue(UserDefaultsManager.loadGroups().isEmpty)
    }
}
