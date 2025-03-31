//
//  GroupsListViewModelTests.swift
//  Gatherly-SwiftUITests
//
//  Created by Sami Alhamad on 3/30/25.
//

import XCTest
@testable import Gatherly_SwiftUI

final class GroupsListViewModelTests: XCTestCase {
    
    func testAllGroups() {
        let user = User(firstName: "Sami", groupIDs: [1, 2], id: 1)
        let group1 = UserGroup(id: 1, name: "Study Buddies", memberIDs: [1, 2], leaderID: 1, messages: nil)
        let group2 = UserGroup(id: 2, name: "Running Club", memberIDs: [1, 3], leaderID: 2, messages: nil)
        let group3 = UserGroup(id: 3, name: "Not Mine", memberIDs: [4], leaderID: 4, messages: nil)
        
        let viewModel = GroupsListViewModel(
            currentUserID: 1,
            allUsers: [user],
            allUserGroups: [group1, group2, group3]
        )
        
        let groups = viewModel.groups
        XCTAssertEqual(groups.count, 2)
        XCTAssertTrue(groups.contains(where: { $0.id == 1 }))
        XCTAssertTrue(groups.contains(where: { $0.id == 2 }))
        XCTAssertFalse(groups.contains(where: { $0.id == 3 }))
    }
    
    func testFilteredGroups_EmptySearch() {
        let user = User(firstName: "Sami", groupIDs: [1], id: 1)
        let group = UserGroup(id: 1, name: "Chess Club", memberIDs: [1], leaderID: 1, messages: nil)
        
        let viewModel = GroupsListViewModel(
            currentUserID: 1,
            allUsers: [user],
            allUserGroups: [group]
        )
        
        viewModel.searchText = ""
        XCTAssertEqual(viewModel.filteredGroups, viewModel.groups)
    }
    
    func testFilteredGroups_WithMatch() {
        let user = User(firstName: "Sami", groupIDs: [1, 2], id: 1)
        let group1 = UserGroup(id: 1, name: "Group I Lead", memberIDs: [1], leaderID: 1, messages: nil)
        let group2 = UserGroup(id: 2, name: "Basketball Team", memberIDs: [1, 2], leaderID: 2, messages: nil)
        
        let viewModel = GroupsListViewModel(
            currentUserID: 1,
            allUsers: [user],
            allUserGroups: [group1, group2]
        )
        
        viewModel.searchText = "lead"
        XCTAssertEqual(viewModel.filteredGroups.count, 1)
        XCTAssertEqual(viewModel.filteredGroups.first?.id, 1)
    }
    
    func testFilteredGroups_NoMatch() {
        let user = User(firstName: "Sami", groupIDs: [1], id: 1)
        let group = UserGroup(id: 1, name: "Board Games", memberIDs: [1], leaderID: 1, messages: nil)
        
        let viewModel = GroupsListViewModel(
            currentUserID: 1,
            allUsers: [user],
            allUserGroups: [group]
        )
        
        viewModel.searchText = "cycling"
        XCTAssertTrue(viewModel.filteredGroups.isEmpty)
    }
}
