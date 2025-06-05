//
//  DeleteUserTests.swift
//  Gatherly-SwiftUITests
//
//  Created by Sami Alhamad on 5/18/25.
//

import Combine
import XCTest
@testable import Gatherly_SwiftUI

final class DeleteUserTests: XCTestCase {
    
    var cancellables = Set<AnyCancellable>()
    
    override func setUp() {
        super.setUp()
        UserDefaultsManager.removeUsers()
    }
    
    override func tearDown() {
        UserDefaultsManager.removeUsers()
        super.tearDown()
    }
    
    func testDeleteUser() {
        let expectation = XCTestExpectation(description: "User is deleted and remaining users are returned")
        
        let userToDelete = User(
            createdTimestamp: Int(Date().timestamp),
            eventIDs: [],
            firstName: "Delete",
            friendIDs: [],
            groupIDs: [],
            id: 101,
            lastName: "Me",
            phone: nil
        )
        
        let userToKeep = User(
            createdTimestamp: Int(Date().timestamp),
            eventIDs: [],
            firstName: "Keep",
            friendIDs: [],
            groupIDs: [],
            id: 102,
            lastName: "Me",
            phone: nil
        )
        
        UserDefaultsManager.saveUsers([
            userToDelete.id!: userToDelete,
            userToKeep.id!: userToKeep
        ])
        
        GatherlyAPI.deleteUser(id: userToDelete.id!)
            .sink { success in
                XCTAssertTrue(success, "Expected deleteUser to return true")
                
                let storedDict = UserDefaultsManager.loadUsers()
                
                XCTAssertEqual(storedDict.count, 1)
                XCTAssertFalse(storedDict.keys.contains(userToDelete.id!))
                XCTAssertTrue(storedDict.keys.contains(userToKeep.id!))
                
                if let keptUser = storedDict[userToKeep.id!] {
                    XCTAssertEqual(keptUser.firstName, "Keep")
                    XCTAssertEqual(keptUser.lastName, "Me")
                } else {
                    XCTFail("No user found under key \(userToKeep.id!)")
                }
                
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 2)
    }
    
    func testDeleteUserFailsForNonexistentUser() {
        let expectation = XCTestExpectation(description: "Deletion should fail for nonexistent user")
        
        let fakeUser = User(
            createdTimestamp: Int(Date().timestamp),
            eventIDs: [],
            firstName: "Ghost",
            friendIDs: [],
            groupIDs: [],
            id: 999,
            lastName: "User",
            phone: nil
        )
        
        UserDefaultsManager.saveUsers([:])
        
        GatherlyAPI.deleteUser(id: fakeUser.id!)
            .sink { success in
                XCTAssertFalse(success)
                
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 2)
    }
}
