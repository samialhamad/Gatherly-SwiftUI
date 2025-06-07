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
}
