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
        let group1 = UserGroup(id: 1, name: "Team Alpha", memberIDs: [1, 2], leaderID: 1, messages: nil)
        let group2 = UserGroup(id: 1, name: "Team Alpha", memberIDs: [1, 2], leaderID: 1, messages: nil)
        XCTAssertEqual(group1, group2)
    }
    
    func testEqualFalse() {
        let group1 = UserGroup(id: 1, name: "Team Alpha", memberIDs: [1, 2], leaderID: 1, messages: nil)
        let group2 = UserGroup(id: 2, name: "Team Beta", memberIDs: [2, 3], leaderID: 2, messages: nil)
        XCTAssertNotEqual(group1, group2)
    }
    
    // MARK: - Computed Vars
    
    func testHasMessagesTrue() {
        let messages = [
            Message(id: 1, userID: 1, message: "Hello", read: true)
        ]
        let group = UserGroup(id: 1, name: "Chat Group", memberIDs: [1, 2], leaderID: 1, messages: messages)
        XCTAssertTrue(group.hasMessages)
    }
    
    func testHasMessagesFalse_Empty() {
        let group = UserGroup(id: 1, name: "Empty Group", memberIDs: [1, 2], leaderID: 1, messages: [])
        XCTAssertFalse(group.hasMessages)
    }
    
    func testHasMessagesFalse_Nil() {
        let group = UserGroup(id: 1, name: "Nil Group", memberIDs: [1, 2], leaderID: 1, messages: nil)
        XCTAssertFalse(group.hasMessages)
    }
    
    func testHasMembersTrue() {
        let group = UserGroup(id: 1, name: "Filled Group", memberIDs: [1], leaderID: 1, messages: nil)
        XCTAssertTrue(group.hasMembers)
    }
    
    func testHasMembersFalse() {
        let group = UserGroup(id: 1, name: "Empty Group", memberIDs: [], leaderID: 1, messages: nil)
        XCTAssertFalse(group.hasMembers)
    }
    
}
