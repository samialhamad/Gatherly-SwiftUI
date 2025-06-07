//
//  GroupDetailViewModelTests.swift
//  Gatherly-SwiftUITests
//
//  Created by Sami Alhamad on 6/7/25.
//

import XCTest
@testable import Gatherly_SwiftUI

final class GroupDetailViewModelTests: XCTestCase {
    
    var viewModel: GroupDetailViewModel!
    
    override func setUpWithError() throws {
        super.setUp()
        viewModel = GroupDetailViewModel()
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        super.tearDown()
    }
    
    // MARK: - Computed Vars
    
    func testFriendsDict() {
        var userA = User(id: 1)
        var userB = User(id: 2)
        let friendsDict = viewModel.friendsDict(for: [userA, userB])
        
        XCTAssertEqual(friendsDict.count, 2)
        XCTAssertEqual(friendsDict[1]?.id, userA.id)
        XCTAssertEqual(friendsDict[2]?.id, userB.id)
    }
    
    func testFriendsDict_returnsEmptyDictionary() {
        let friendsDict = viewModel.friendsDict(for: [])
        XCTAssertTrue(friendsDict.isEmpty)
    }
    
    func testGroup() {
        let group1 = UserGroup(id: 1, leaderID: 1, memberIDs: [], name: "First")
        let group2 = UserGroup(id: 2, leaderID: 2, memberIDs: [], name: "Second")
        let groups = [group1, group2]

        let group = viewModel.group(forID: 2, in: groups)
        
        XCTAssertEqual(group?.id, group2.id)
        XCTAssertEqual(group?.name, group2.name)
    }
    
    func testGroup_returnsNil() {
        let group1 = UserGroup(id: 10, leaderID: 1, memberIDs: [], name: "Group")
        let group = viewModel.group(forID: 0, in: [group1])
        
        XCTAssertNil(group)
    }
    
    // MARK: - Functions
    
    func testLeader_returnsCurrentUser() {
        let currentUser = User(id: 1)
        let group = UserGroup(id: 1, leaderID: 1, memberIDs: [])
        let friendsDict: [Int: User] = [:]
        
        let leader = viewModel.leader(
            for: group,
            currentUser: currentUser,
            friendsDict: friendsDict
        )
        
        XCTAssertEqual(leader?.id, currentUser.id)
    }
    
    func testLeader_returnsFriend() {
        let friend = User(id: 2)
        let group = UserGroup(id: 1, leaderID: 2, memberIDs: [])
        let friendsDict: [Int: User] = [2: friend]
        
        let leader = viewModel.leader(
            for: group,
            currentUser: nil,
            friendsDict: friendsDict
        )
        
        XCTAssertEqual(leader?.id, friend.id)
    }
    
    func testMembers() {
        let currentUser = User(id: 1)
        let friendA = User(id: 2)
        let friendB = User(id: 3)
        
        let group = UserGroup(id: 1, leaderID: 5, memberIDs: [1, 2, 3])
        let friendsDict: [Int: User] = [2: friendA, 3: friendB]
        
        let members = viewModel.members(
            for: group,
            currentUser: currentUser,
            friendsDict: friendsDict
        )
        
        XCTAssertEqual(members.map { $0.id }, [1, 2, 3])
    }
    
    func testMembers_returnsEmpty() {
        let group = UserGroup(id: 1, leaderID: 1, memberIDs: [3, 4])
        let friendsDict: [Int: User] = [:]
        
        let members = viewModel.members(
            for: group,
            currentUser: nil,
            friendsDict: friendsDict
        )
        
        XCTAssertTrue(members.isEmpty)
    }
}
