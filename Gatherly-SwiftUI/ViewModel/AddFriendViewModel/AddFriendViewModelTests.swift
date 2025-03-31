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
        User(firstName: "Alice", id: 1, lastName: "Smith"),
        User(firstName: "Bob", id: 2, lastName: "Johnson"),
        User(firstName: "Charlie", id: 3, lastName: "Brown"),
        User(firstName: "David", id: 4, lastName: "Smith"),
        User(firstName: "Eve", id: 5, lastName: "Davis")
    ]
    
    func testFilteredUsers_EmptySearchText() {
        let currentUser = User(friendIDs: [], id: 1)
        
        let viewModel = AddFriendViewModel(currentUser: currentUser, allUsers: sampleUsers)
        
        viewModel.searchText = ""
        let result = viewModel.filteredUsers
        
        XCTAssertTrue(result.isEmpty)
    }
    
    func testFilteredUsers_MatchingFirstName() {
        let currentUser = User(friendIDs: [], id: 1)
        let viewModel = AddFriendViewModel(currentUser: currentUser, allUsers: sampleUsers)
        
        
        viewModel.searchText = "bob"
        let result = viewModel.filteredUsers
        
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.firstName, "Bob")
    }
    
    func testFilteredUsers_MatchingLastName() {
        let currentUser = User(friendIDs: [], id: 1)
        let viewModel = AddFriendViewModel(currentUser: currentUser, allUsers: sampleUsers)
        
        viewModel.searchText = "smith"
        let result = viewModel.filteredUsers
        
        // Should match "Alice Smith" and "David Smith", but alice is currentUser so excluded
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.firstName, "David")
    }
    
    func testFilteredUsers_ExcludesCurrentUser() {
        let currentUser = User(firstName: "Charlie", friendIDs: [], id: 3)
        let viewModel = AddFriendViewModel(currentUser: currentUser, allUsers: sampleUsers)
        
        viewModel.searchText = "charlie"
        let result = viewModel.filteredUsers
        
        XCTAssertTrue(result.isEmpty)
    }
    
    func testFilteredUsers_ExcludesAlreadyFriends() {
        let currentUser = User(friendIDs: [2], id: 1)
        let viewModel = AddFriendViewModel(currentUser: currentUser, allUsers: sampleUsers)
        
        viewModel.searchText = "bob"
        let result = viewModel.filteredUsers
        
        XCTAssertTrue(result.isEmpty)
    }
    
    func testFilteredUsers_TrimsWhitespaceAndIsCaseInsensitive() {
        let currentUser = User(friendIDs: [], id: 1)
        let viewModel = AddFriendViewModel(currentUser: currentUser, allUsers: sampleUsers)
        
        viewModel.searchText = "  DAVIS  "
        let result = viewModel.filteredUsers
        
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.firstName, "Eve")
    }
}
