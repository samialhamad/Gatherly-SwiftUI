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
    }
    
    
    override func tearDown() {
        UserDefaultsManager.resetAll()
        super.tearDown()
    }
    
    func testSeedsSampleDataWhenNotUITesting() {
        let originalArgs = CommandLine.arguments
        CommandLine.arguments = ["TestAppExecutable"] // no "--uitesting"
        
        XCTAssertFalse(UserDefaultsManager.getDidSeedSampleData())
        
        AppInitializer.runIfNeeded()
        XCTAssertTrue(UserDefaultsManager.getDidSeedSampleData())
        
        let allUsers = UserDefaultsManager.loadUsers()
        let allEvents = UserDefaultsManager.loadEvents()
        let allGroups = UserDefaultsManager.loadGroups()
        
        XCTAssertEqual(allUsers.count, SampleData.sampleUsers.count)
        guard let sami = allUsers.first(where: { $0.id == 1 }) else {
            XCTFail("Expected to find a user whose id == 1 in saved users")
            CommandLine.arguments = originalArgs
            return
        }
        
        XCTAssertEqual(sami.friendIDs?.sorted(), [2, 3, 4])
        
        let expectedEventIDs: [Int] = SampleData
            .sampleEvents
            .filter { $0.plannerID == 1 || ($0.memberIDs?.contains(1) ?? false) }
            .compactMap { $0.id }
        XCTAssertEqual(Set(sami.eventIDs ?? []), Set(expectedEventIDs))
        
        let expectedGroupIDs: [Int] = SampleData
            .sampleGroups
            .filter { $0.leaderID == 1 || $0.memberIDs.contains(1) }
            .compactMap { $0.id }
        XCTAssertEqual(Set(sami.groupIDs ?? []), Set(expectedGroupIDs))
        
        let currentUser = UserDefaultsManager.loadCurrentUser()
        XCTAssertNotNil(currentUser)
        XCTAssertEqual(currentUser?.id, 1)
        XCTAssertEqual(allEvents.count, SampleData.sampleEvents.count)
        XCTAssertEqual(allGroups.count, SampleData.sampleGroups.count)
        
        CommandLine.arguments = originalArgs
    }
    
    func testSeedsSampleDataWhenUITesting() {
        let originalArgs = CommandLine.arguments
        CommandLine.arguments = ["TestAppExecutable", "--uitesting"]
        
        UserDefaultsManager.setDidSeedSampleData(true)
        
        let dummyUser = User(
            createdTimestamp: Int(Date().timeIntervalSince1970),
            deviceToken: nil,
            email: "dummy@example.com",
            eventIDs: [],
            firstName: "Dummy",
            friendIDs: [],
            groupIDs: [],
            id: 99,
            isEmailEnabled: true,
            lastName: "User",
            phone: nil
        )
        UserDefaultsManager.saveUsers([dummyUser])
        UserDefaultsManager.saveEvents([])
        UserDefaultsManager.saveGroups([])
        UserDefaultsManager.saveCurrentUser(dummyUser)
        
        XCTAssertTrue(UserDefaultsManager.getDidSeedSampleData())
        XCTAssertEqual(UserDefaultsManager.loadUsers().map { $0.id }, [99])
        
        AppInitializer.runIfNeeded()
        
        XCTAssertTrue(UserDefaultsManager.getDidSeedSampleData())
        
        // The dummy user should be gone only sampleUsers should remain
        let storedIDs = Set(UserDefaultsManager.loadUsers().map { $0.id })
        let expectedIDs = Set(SampleData.sampleUsers.map { $0.id })
        XCTAssertEqual(storedIDs, expectedIDs)
        
        XCTAssertEqual(UserDefaultsManager.loadEvents().count, SampleData.sampleEvents.count)
        XCTAssertEqual(UserDefaultsManager.loadGroups().count, SampleData.sampleGroups.count)
        
        CommandLine.arguments = originalArgs
    }
    
    func testDoesNotReapplySampleDataIfAlreadySeededAndNotUITesting() {
        let originalArgs = CommandLine.arguments
        CommandLine.arguments = ["TestAppExecutable"]
        
        AppInitializer.runIfNeeded()
        XCTAssertTrue(UserDefaultsManager.getDidSeedSampleData())
        
        var usersAfterFirstSeed = UserDefaultsManager.loadUsers()
        
        if var sami = usersAfterFirstSeed.first(where: { $0.id == 1 }) {
            sami.firstName = "Modified"
            if let index = usersAfterFirstSeed.firstIndex(where: { $0.id == 1 }) {
                usersAfterFirstSeed[index] = sami
                UserDefaultsManager.saveUsers(usersAfterFirstSeed)
            }
        }
        
        let updatedUser = UserDefaultsManager
            .loadUsers()
            .first(where: { $0.id == 1 })
        XCTAssertEqual(updatedUser?.firstName, "Modified")
        
        AppInitializer.runIfNeeded()
        
        let usersAfterSecondRun = UserDefaultsManager.loadUsers()
        let samiAfterSecondRun = usersAfterSecondRun.first(where: { $0.id == 1 })
        XCTAssertEqual(samiAfterSecondRun?.firstName, "Modified")
        
        CommandLine.arguments = originalArgs
    }
}
