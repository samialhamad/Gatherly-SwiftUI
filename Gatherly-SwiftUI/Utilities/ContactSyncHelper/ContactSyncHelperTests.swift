//
//  ContactSyncHelperTests.swift
//  Gatherly-SwiftUITests
//
//  Created by Sami Alhamad on 5/31/25.
//

import XCTest
@testable import Gatherly_SwiftUI

final class ContactSyncHelperTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        UserDefaultsManager.resetAll()
        
        let dummyUser = User(
            createdTimestamp: Int(Date().timeIntervalSince1970),
            deviceToken: nil,
            email: "sami@example.com",
            eventIDs: [],
            firstName: "Sami",
            friendIDs: [],
            groupIDs: [],
            id: 1,
            isEmailEnabled: true,
            lastName: "Alhamad",
            phone: "1112223333"
        )
        UserDefaultsManager.saveUsers([dummyUser])
        UserDefaultsManager.saveCurrentUser(dummyUser)
    }
    
    override func tearDown() {
        UserDefaultsManager.resetAll()
        super.tearDown()
    }
    
    func testRunIfNeeded_setsDidSyncContacts_whenNotPreviouslySynced() async {
        XCTAssertFalse(
            UserDefaultsManager.getDidSyncContacts()
        )
        
        await ContactSyncHelper.runIfNeeded(currentUserID: 1)
        
        XCTAssertTrue(
            UserDefaultsManager.getDidSyncContacts()
        )
        
        let allUsers = UserDefaultsManager.loadUsers()
        XCTAssertGreaterThanOrEqual(allUsers.count, 1)

        let foundIDs = allUsers.map { $0.id }
        XCTAssertTrue(foundIDs.contains(1))
    }
    
    func testRunIfNeeded_doesNothing_whenAlreadySynced() async {
        UserDefaultsManager.setDidSyncContacts(true)
        
        let beforeUsers = UserDefaultsManager.loadUsers()
        
        await ContactSyncHelper.runIfNeeded(currentUserID: 1)
        
        XCTAssertTrue(UserDefaultsManager.getDidSyncContacts())
        
        let afterUsers = UserDefaultsManager.loadUsers()
        XCTAssertEqual(beforeUsers.map { $0.id }, afterUsers.map { $0.id })
    }
    
    func testForceSync_setsFlagAndInvokesCompletion() {
        XCTAssertFalse(UserDefaultsManager.getDidSyncContacts())
        
        let completionExpectation = expectation(description: "forceSync completion invoked")
        
        ContactSyncHelper.forceSync(currentUserID: 1) {
            XCTAssertTrue(UserDefaultsManager.getDidSyncContacts())
            
            completionExpectation.fulfill()
        }
        
        wait(for: [completionExpectation], timeout: 5.0)
    }
    
    func testForceSync_alwaysInvokesCompletion_ifAlreadySynced() {
        let firstExpectation = expectation(description: "first forceSync completion")
        ContactSyncHelper.forceSync(currentUserID: 1) {
            XCTAssertTrue(UserDefaultsManager.getDidSyncContacts())
            firstExpectation.fulfill()
        }
        wait(for: [firstExpectation], timeout: 5.0)
        
        let secondExpectation = expectation(description: "second forceSync completion")
        ContactSyncHelper.forceSync(currentUserID: 1) {
            XCTAssertTrue(UserDefaultsManager.getDidSyncContacts())
            secondExpectation.fulfill()
        }
        
        wait(for: [secondExpectation], timeout: 5.0)
    }
}
