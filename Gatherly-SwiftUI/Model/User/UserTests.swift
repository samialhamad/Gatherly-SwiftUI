//
//  UserTests.swift
//  Gatherly-SwiftUITests
//
//  Created by Sami Alhamad on 3/4/25.
//

import XCTest
@testable import Gatherly_SwiftUI

final class UserTests: XCTestCase {
    
    // MARK: - Equatable
    
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
    
    // MARK: - Functions
    
    func testFriends_returnsCorrectUsers() {
        let user = User(friendIDs: [2, 3], id: 1)
        
        let friend2 = User(firstName: "Alice", id: 2)
        let friend3 = User(firstName: "Bob", id: 3)
        let unrelated = User(firstName: "Zoe", id: 99)
        
        let lookup: [Int: User] = [
            2: friend2,
            3: friend3,
            99: unrelated
        ]
        
        let friends = user.friends(from: lookup)
        
        XCTAssertEqual(friends.count, 2)
        XCTAssertTrue(friends.contains(where: { $0.id == 2 }))
        XCTAssertTrue(friends.contains(where: { $0.id == 3 }))
    }
    
    func testFriends_returnsEmptyIfNoIDs() {
        let user = User(friendIDs: nil, id: 1)
        let lookup: [Int: User] = [2: User(id: 2), 3: User(id: 3)]
        
        let friends = user.friends(from: lookup)
        
        XCTAssertTrue(friends.isEmpty)
    }
    
    func testGroups_returnsCorrectGroups() {
        let user = User(groupIDs: [10, 20], id: 1)
        
        let groupA = UserGroup(id: 10, leaderID: 1, memberIDs: [1], name: "Group A")
        let groupB = UserGroup(id: 20, leaderID: 1, memberIDs: [1], name: "Group B")
        let groupC = UserGroup(id: 99, leaderID: 2, memberIDs: [2], name: "Unrelated")
        
        let allGroups = [groupA, groupB, groupC]
        
        let groups = user.groups(from: allGroups)
        
        XCTAssertEqual(groups.count, 2)
        XCTAssertTrue(groups.contains(where: { $0.id == 10 }))
        XCTAssertTrue(groups.contains(where: { $0.id == 20 }))
    }
    
    func testGroups_returnsEmptyIfNoIDs() {
        let user = User(groupIDs: nil, id: 1)
        let group = [UserGroup(id: 1, leaderID: 1, memberIDs: [1], name: "Test")]
        
        let groups = user.groups(from: group)
        
        XCTAssertTrue(groups.isEmpty)
    }
}
