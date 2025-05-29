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
    
    func testDeleteUser() {
        let expectation = XCTestExpectation(description: "User is deleted and remaining users are returned")
        
        let userToDelete = User(
            createdTimestamp: Int(Date().timestamp),
            email: "delete@example.com",
            eventIDs: [],
            firstName: "Delete",
            friendIDs: [],
            groupIDs: [],
            id: 101,
            isEmailEnabled: false,
            lastName: "Me",
            phone: nil
        )
        
        let userToKeep = User(
            createdTimestamp: Int(Date().timestamp),
            email: "keep@example.com",
            eventIDs: [],
            firstName: "Keep",
            friendIDs: [],
            groupIDs: [],
            id: 102,
            isEmailEnabled: false,
            lastName: "Me",
            phone: nil
        )
        
        UserDefaultsManager.saveUsers([userToDelete, userToKeep])
        
        GatherlyAPI.deleteUser(userToDelete)
            .sink { _ in 
                let storedUsers = UserDefaultsManager.loadUsers()
                XCTAssertEqual(storedUsers.count, 1)
                XCTAssertFalse(storedUsers.contains { $0.id == userToDelete.id })
                XCTAssertTrue(storedUsers.contains { $0.id == userToKeep.id })
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 2)
    }
}
