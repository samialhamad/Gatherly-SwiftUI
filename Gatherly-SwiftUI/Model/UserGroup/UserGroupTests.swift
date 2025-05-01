//
//  UserGroupTests.swift
//  Gatherly-SwiftUITests
//
//  Created by Sami Alhamad on 3/27/25.
//

import XCTest
@testable import Gatherly_SwiftUI

final class UserGroupTests: XCTestCase {
    
    // MARK: - Equatable
    
    func testEqualTrue() {
        let group1 = UserGroup(id: 1, leaderID: 1, memberIDs: [1, 2], name: "Team Alpha")
        let group2 = UserGroup(id: 1, leaderID: 1, memberIDs: [1, 2], name: "Team Alpha")
        XCTAssertEqual(group1, group2)
    }
    
    func testEqualFalse() {
        let group1 = UserGroup(id: 1, leaderID: 1, memberIDs: [1, 2], name: "Team Alpha")
        let group2 = UserGroup(id: 2, leaderID: 2, memberIDs: [2, 3], name: "Team Beta")
        XCTAssertNotEqual(group1, group2)
    }
    
    // MARK: - Computed Vars
    
    func testHasMessagesTrue() {
        let messages = [
            Message(id: 1, userID: 1, message: "Hello", read: true)
        ]
        let group = UserGroup(id: 1, leaderID: 1, memberIDs: [1, 2], messages: messages, name: "Chat Group")
        XCTAssertTrue(group.hasMessages)
    }
    
    func testHasMessagesFalse_Empty() {
        let group = UserGroup(id: 1, leaderID: 1, memberIDs: [1, 2], messages: [], name: "Empty Group")
        XCTAssertFalse(group.hasMessages)
    }
    
    func testHasMessagesFalse_Nil() {
        let group = UserGroup(id: 1, leaderID: 1, memberIDs: [1, 2], messages: nil, name: "Nil Group")
        XCTAssertFalse(group.hasMessages)
    }
    
    func testHasMembersTrue() {
        let group = UserGroup(id: 1, leaderID: 1, memberIDs: [1], name: "Filled Group")
        XCTAssertTrue(group.hasMembers)
    }
    
    func testHasMembersFalse() {
        let group = UserGroup(id: 1, leaderID: 1, memberIDs: [], name: "Empty Group")
        XCTAssertFalse(group.hasMembers)
    }
}

