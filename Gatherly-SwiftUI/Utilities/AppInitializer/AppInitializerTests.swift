//
//  AppInitializerTests.swift
//  Gatherly-SwiftUITests
//
//  Created by Sami Alhamad on 5/31/25.
//

import XCTest
@testable import Gatherly_SwiftUI

final class AppInitializerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        UserDefaultsManager.resetAll()
        unsetenv("UITESTING")
    }
    
    override func tearDown() {
        UserDefaultsManager.resetAll()
        unsetenv("UITESTING")
        super.tearDown()
    }
    
    func testSeedsSampleDataWhenNotUITesting() {
        unsetenv("UITESTING")
        
        XCTAssertFalse(UserDefaultsManager.getDidSeedSampleData())
        
        AppInitializer.runIfNeeded()
        XCTAssertTrue(UserDefaultsManager.getDidSeedSampleData())
        
        let allUsers = Array(UserDefaultsManager.loadUsers().values)
        let allEvents = UserDefaultsManager.loadEvents()
        let allGroups = UserDefaultsManager.loadGroups()
        
        XCTAssertEqual(allUsers.count, SampleData.sampleUsers.count)
        
        guard let sami = allUsers.first(where: { $0.id == SampleData.currentUserID }) else {
            XCTFail("Expected to find a user whose id == 1 in saved users")
            return
        }
        
        XCTAssertEqual(sami.friendIDs?.sorted(), [2, 3, 4])
        
        let expectedGroupIDs: [Int] = SampleData
            .sampleGroups
            .filter { $0.leaderID == SampleData.currentUserID || $0.memberIDs.contains(SampleData.currentUserID) }
            .compactMap { $0.id }
        XCTAssertEqual(Set(sami.groupIDs ?? []), Set(expectedGroupIDs))
        
        let currentUser = UserDefaultsManager.loadCurrentUser()
        
        XCTAssertNotNil(currentUser)
        XCTAssertEqual(currentUser?.id, SampleData.currentUserID)
        XCTAssertEqual(allEvents.count, SampleData.sampleEvents.count)
        XCTAssertEqual(allGroups.count, SampleData.sampleGroups.count)
    }
    
    func testSeedsSampleDataWhenUITesting() {
        setenv("UITESTING", "1", 1)
        
        UserDefaultsManager.setDidSeedSampleData(true)
        
        let dummyUser = User(
            createdTimestamp: Int(Date().timestamp),
            eventIDs: [],
            firstName: "Dummy",
            friendIDs: [],
            groupIDs: [],
            id: 99,
            lastName: "User",
            phone: nil
        )
        UserDefaultsManager.saveUsers([dummyUser.id!: dummyUser])
        UserDefaultsManager.saveEvents([:])
        UserDefaultsManager.saveGroups([:])
        UserDefaultsManager.saveCurrentUser(dummyUser)
        
        XCTAssertTrue(UserDefaultsManager.getDidSeedSampleData())
        
        AppInitializer.runIfNeeded()
        
        XCTAssertTrue(UserDefaultsManager.getDidSeedSampleData())
        
        // The dummy user should be gone only sampleUsers should remain
        let storedIDs = Set(UserDefaultsManager.loadUsers().keys)
        let expectedIDs = Set(SampleData.sampleUsers.map { $0.id })
        
        XCTAssertEqual(storedIDs, expectedIDs)
        XCTAssertEqual(UserDefaultsManager.loadEvents().count, SampleData.sampleEvents.count)
        XCTAssertEqual(UserDefaultsManager.loadGroups().count, SampleData.sampleGroups.count)
    }
    
    func testDoesNotReapplySampleDataIfAlreadySeededAndNotUITesting() {
        unsetenv("UITESTING")
        
        AppInitializer.runIfNeeded()
        XCTAssertTrue(UserDefaultsManager.getDidSeedSampleData())
        
        var usersDict = UserDefaultsManager.loadUsers()
        if var sami = usersDict[SampleData.currentUserID] {
            sami.firstName = "Modified"
            usersDict[SampleData.currentUserID] = sami
            UserDefaultsManager.saveUsers(usersDict)
        }
        
        let updatedUser = UserDefaultsManager.loadUsers()[SampleData.currentUserID]
        XCTAssertEqual(updatedUser?.firstName, "Modified")
        
        AppInitializer.runIfNeeded()
        
        let usersAfterSecondRun = UserDefaultsManager.loadUsers()
        let samiAfterSecondRun = usersAfterSecondRun[SampleData.currentUserID]
        
        XCTAssertEqual(samiAfterSecondRun?.firstName, "Modified")
    }
}
