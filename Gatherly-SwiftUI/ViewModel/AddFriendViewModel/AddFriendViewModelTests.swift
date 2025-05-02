//
//  AddFriendViewModelTests.swift
//  Gatherly-SwiftUITests
//
//  Created by Sami Alhamad on 3/31/25.
//

import XCTest
@testable import Gatherly_SwiftUI

final class AddFriendViewModelTests: XCTestCase {
    
    let sampleUsers: [User] = [
        User(firstName: "Alice", friendIDs: [2, 3], id: 1, lastName: "Smith"),
        User(firstName: "Bob", id: 2, lastName: "Johnson"),
        User(firstName: "Charlie", id: 3, lastName: "Brown"),
        User(firstName: "David", id: 4, lastName: "Smith"),
        User(firstName: "Eve", id: 5, lastName: "Davis")
    ]
    
    func testFilteredUsers_emptySearchText() {
        let viewModel = AddFriendViewModel(currentUserID: 1, allUsers: sampleUsers)
        viewModel.searchText = ""
        
        let result = viewModel.filteredUsers
        
        XCTAssertTrue(result.isEmpty)
    }
    
    func testFilteredUsers_matchingFirstName() {
        let viewModel = AddFriendViewModel(currentUserID: 1, allUsers: sampleUsers)
        viewModel.searchText = "eve"
        
        let result = viewModel.filteredUsers
        
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.firstName, "Eve")
    }
    
    func testFilteredUsers_matchingLastName() {
        let viewModel = AddFriendViewModel(currentUserID: 1, allUsers: sampleUsers)
        viewModel.searchText = "smith"
        
        let result = viewModel.filteredUsers
        
        // Should match "Alice Smith" and "David Smith", but alice is currentUser so excluded
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.firstName, "David")
    }
    
    func testFilteredUsers_excludesCurrentUser() {
        let viewModel = AddFriendViewModel(currentUserID: 1, allUsers: sampleUsers)
        viewModel.searchText = "charlie"
        
        let result = viewModel.filteredUsers
        
        XCTAssertTrue(result.isEmpty)
    }
    
    func testFilteredUsers_excludesAlreadyFriends() {
        let viewModel = AddFriendViewModel(currentUserID: 1, allUsers: sampleUsers)
        viewModel.searchText = "bob"
        
        let result = viewModel.filteredUsers
        
        XCTAssertTrue(result.isEmpty)
    }
    
    func testFilteredUsers_trimsWhitespaceAndIsCaseInsensitive() {
        let viewModel = AddFriendViewModel(currentUserID: 1, allUsers: sampleUsers)
        viewModel.searchText = "  DAVIS  "
        
        let result = viewModel.filteredUsers
        
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.firstName, "Eve")
    }
}
