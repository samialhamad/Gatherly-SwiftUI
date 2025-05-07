//
//  UserTests.swift
//  Gatherly-SwiftUITests
//
//  Created by Sami Alhamad on 3/4/25.
//

import XCTest
@testable import Gatherly_SwiftUI

final class UserTests: XCTestCase {
    
    //MARK: - Equatable
    
    func testEqualTrue() {
        let user0 = User(firstName: "Sami", id: 0)
        let user1 = User(firstName: "Sami", id: 0)
        
        XCTAssertEqual(user0, user1)
    }
    
    func testEqualFalse() {
        let user0 = User(firstName: "Sami", id: 0)
        let user1 = User(firstName: "Matt", id: 1)
        
        XCTAssertNotEqual(user0, user1)
    }
    
    //MARK: - Computed Vars
    
    func testUserHasEventsTrue() {
        let user0 = User(eventIDs: [1], firstName: "Sami", id: 0)
        XCTAssertTrue(user0.hasEvents)
    }
    
    func testUserHasEventsFalse() {
        let user0 = User(eventIDs: [], firstName: "Sami", id: 0)
        XCTAssertFalse(user0.hasEvents)
    }
    
    func testUserHasEventsNil() {
        let user0 = User(firstName: "Sami", id: 0)
        XCTAssertFalse(user0.hasEvents)
    }
    
    func testUserHasFriendsTrue() {
        let user0 = User(firstName: "Sami", friendIDs: [1], id: 0)
        XCTAssertTrue(user0.hasFriends)
    }
    
    func testUserHasFriendsFalse() {
        let user0 = User(firstName: "Sami", friendIDs: [], id: 0)
        XCTAssertFalse(user0.hasFriends)
    }
    
    func testUserHasFriendsNil() {
        let user0 = User(firstName: "Sami", id: 0)
        XCTAssertFalse(user0.hasFriends)
    }
    
    func testUserHasGroupsTrue() {
        let user = User(firstName: "Sami", groupIDs: [1, 2], id: 0)
        XCTAssertTrue(user.hasGroups)
    }
    
    func testUserHasGroupsFalse() {
        let user = User(firstName: "Sami", groupIDs: [], id: 0)
        XCTAssertFalse(user.hasGroups)
    }
    
    //MARK: - Functions
    
    func testResolvedFriends_returnsCorrectUsers() {
        let user = User(friendIDs: [2, 3], id: 1)
        
        let friend2 = User(firstName: "Alice", id: 2)
        let friend3 = User(firstName: "Bob", id: 3)
        let unrelated = User(firstName: "Zoe", id: 99)
        
        let lookup: [Int: User] = [
            2: friend2,
            3: friend3,
            99: unrelated
        ]
        
        let resolvedFriends = user.resolvedFriends(from: lookup)
        
        XCTAssertEqual(resolvedFriends.count, 2)
        XCTAssertTrue(resolvedFriends.contains(where: { $0.id == 2 }))
        XCTAssertTrue(resolvedFriends.contains(where: { $0.id == 3 }))
    }
    
    func testResolvedFriends_returnsEmptyIfNoIDs() {
        let user = User(friendIDs: nil, id: 1)
        let lookup: [Int: User] = [2: User(id: 2), 3: User(id: 3)]
        
        let resolvedFriends = user.resolvedFriends(from: lookup)
        
        XCTAssertTrue(resolvedFriends.isEmpty)
    }
    
    func testResolvedGroups_returnsCorrectGroups() {
        let user = User(groupIDs: [10, 20], id: 1)
        
        let groupA = UserGroup(id: 10, leaderID: 1, memberIDs: [1], name: "Group A")
        let groupB = UserGroup(id: 20, leaderID: 1, memberIDs: [1], name: "Group B")
        let groupC = UserGroup(id: 99, leaderID: 2, memberIDs: [2], name: "Unrelated")
        
        let allGroups = [groupA, groupB, groupC]
        
        let resolvedGroups = user.resolvedGroups(from: allGroups)
        
        XCTAssertEqual(resolvedGroups.count, 2)
        XCTAssertTrue(resolvedGroups.contains(where: { $0.id == 10 }))
        XCTAssertTrue(resolvedGroups.contains(where: { $0.id == 20 }))
    }
    
    func testResolvedGroups_returnsEmptyIfNoIDs() {
        let user = User(groupIDs: nil, id: 1)
        let groups = [UserGroup(id: 1, leaderID: 1, memberIDs: [1], name: "Test")]
        
        let resolvedGroups = user.resolvedGroups(from: groups)
        
        XCTAssertTrue(resolvedGroups.isEmpty)
    }
    
}
