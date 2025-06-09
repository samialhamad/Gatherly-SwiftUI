//
//  GroupsListViewModelTests.swift
//  Gatherly-SwiftUITests
//
//  Created by Sami Alhamad on 6/8/25.
//

import XCTest
@testable import Gatherly_SwiftUI

final class GroupsListViewModelTests: XCTestCase {
    
    var viewModel: GroupsListViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = GroupsListViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    // MARK: - Helpers
    
    private func makeUser(id: Int, groupIDs: [Int]? = nil) -> User {
        var user = User(firstName: "Test", id: id, lastName: "User")
        user.groupIDs = groupIDs
        return user
    }
    
    private func makeGroup(
        id: Int,
        leaderID: Int,
        memberIDs: [Int],
        name: String? = nil
    ) -> UserGroup {
        UserGroup(id: id,
                  leaderID: leaderID,
                  memberIDs: memberIDs,
                  name: name)
    }
    
    // MARK: - filteredGroups
    
    func testFilteredGroups_whenLeaderOrMember() {
        let group1 = makeGroup(id: 1, leaderID: 10, memberIDs: [], name: "Group I Lead")
        let group2 = makeGroup(id: 2, leaderID: 5, memberIDs: [10], name: "Group I'm a member")
        let group3 = makeGroup(id: 3, leaderID: 5, memberIDs: [3], name: "Group I have nothing to do with")
        let allGroups = [group1, group2, group3]
        
        let filteredGroups = viewModel.filteredGroups(
            from: allGroups,
            searchText: ""
        )
        
        let returnedIDs = Set(filteredGroups.compactMap { $0.id })
        XCTAssertEqual(returnedIDs, Set([1, 2, 3]))
    }
    
    func testFilteredGroups_filtersBySearchText() {
        let group1 = makeGroup(id: 1, leaderID: 1, memberIDs: [], name: "Coffee Club")
        let group2 = makeGroup(id: 2, leaderID: 5, memberIDs: [1], name: "Study Group")
        let allGroups = [group1, group2]
        
        let filteredGroups = viewModel.filteredGroups(
            from: allGroups,
            searchText: "coff"
        )
        
        XCTAssertEqual(filteredGroups.map { $0.id }, [1])
    }
    
}
