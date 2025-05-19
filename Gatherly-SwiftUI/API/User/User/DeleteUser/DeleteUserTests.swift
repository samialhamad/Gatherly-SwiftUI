//
//  DeleteUserTests.swift
//  Gatherly-SwiftUITests
//
//  Created by Sami Alhamad on 5/18/25.
//

import XCTest
@testable import Gatherly_SwiftUI

final class DeleteUserTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        UserDefaultsManager.removeUsers()
    }
    
    func testDeleteUser() async {
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
        
        let allUsersBefore = UserDefaultsManager.loadUsers()
        XCTAssertEqual(allUsersBefore.count, 2)
        
        let updatedUsers = await GatherlyAPI.deleteUser(userToDelete)
        
        XCTAssertEqual(updatedUsers.count, 1)
        XCTAssertFalse(updatedUsers.contains(where: { $0.id == userToDelete.id }))
        XCTAssertTrue(updatedUsers.contains(where: { $0.id == userToKeep.id }))
    }
}
