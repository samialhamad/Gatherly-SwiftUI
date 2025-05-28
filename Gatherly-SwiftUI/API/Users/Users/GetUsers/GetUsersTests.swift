//
//  GetUsersTests.swift
//  Gatherly-SwiftUITests
//
//  Created by Sami Alhamad on 5/27/25.
//

import Combine
import XCTest
@testable import Gatherly_SwiftUI

final class GetUsersTests: XCTestCase {
    
    var cancellables = Set<AnyCancellable>()
    
    override func setUp() {
        super.setUp()
        UserDefaultsManager.removeUsers()
    }
    
    func testGetUsersReturnsFriendsOnly() {
        let expectation = XCTestExpectation(description: "Only friends of user ID 1 are returned")
        
        let currentUser = User(
            createdTimestamp: Int(Date().timestamp),
            eventIDs: [],
            firstName: "Current",
            friendIDs: [2, 3],
            groupIDs: [],
            id: 1,
            lastName: "User"
        )
        
        let friend1 = User(
            createdTimestamp: Int(Date().timestamp),
            firstName: "Alice",
            id: 2,
            lastName: "Smith"
        )
        
        let friend2 = User(
            createdTimestamp: Int(Date().timestamp),
            firstName: "Bob",
            id: 3,
            lastName: "Jones"
        )
        
        let stranger = User(
            createdTimestamp: Int(Date().timestamp),
            firstName: "Eve",
            id: 4,
            lastName: "Hacker"
        )
        
        UserDefaultsManager.saveUsers([currentUser, friend1, friend2, stranger])
        
        GatherlyAPI.getUsers(forUserID: 1)
            .sink { friends in
                XCTAssertEqual(friends.count, 2)
                let friendIDs = friends.compactMap { $0.id }
                XCTAssertTrue(friendIDs.contains(2))
                XCTAssertTrue(friendIDs.contains(3))
                XCTAssertFalse(friendIDs.contains(4))
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 3)
    }
}
