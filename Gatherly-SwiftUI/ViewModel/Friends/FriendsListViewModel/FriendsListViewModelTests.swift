//
//  FriendsListViewTests.swift
//  Gatherly-SwiftUITests
//
//  Created by Sami Alhamad on 3/27/25.
//

import XCTest
@testable import Gatherly_SwiftUI

final class FriendsListViewModelTests: XCTestCase {
    
    func makeUser(id: Int, firstName: String, lastName: String) -> User {
        User(firstName: firstName, id: id, lastName: lastName)
    }
    
    func sampleFriends() -> [User] {
        [
            makeUser(id: 2, firstName: "Friend", lastName: "One"),
            makeUser(id: 3, firstName: "Friend", lastName: "Two")
        ]
    }
    
    // MARK: - Friends
    
    func testFriends() {
        let viewModel = FriendsListViewModel()
        
        let currentUser = makeUser(id: 1, firstName: "Current", lastName: "User")
        currentUser.friendIDs = [2, 4]
        
        let user2 = makeUser(id: 2, firstName: "Two", lastName: "User")
        let user3 = makeUser(id: 3, firstName: "Three", lastName: "User")
        let user4 = makeUser(id: 4, firstName: "Four", lastName: "User")
        let allUsers = [user2, user3, user4]
        
        let result = viewModel.friends(from: allUsers, currentUser: currentUser)
        
        XCTAssertEqual(result.count, 2)
        XCTAssertTrue(result.contains { $0.id == 2 })
        XCTAssertTrue(result.contains { $0.id == 4 })
    }
    
    func testFilteredFriends() {
        let viewModel = FriendsListViewModel()
        let searchText = "tw"
        
        let filtered = viewModel.filteredFriends(from: sampleFriends(), searchText: searchText)
        
        XCTAssertEqual(filtered.count, 1)
        XCTAssertEqual(filtered.first?.lastName, "Two")
    }
    
    func testGroupedFriends() {
        let friends = [
            makeUser(id: 2, firstName: "Matt", lastName: "Simon"),
            makeUser(id: 3, firstName: "Logan", lastName: "Harrison")
        ]
        
        let viewModel = FriendsListViewModel()
        let grouped = viewModel.groupedFriends(from: friends)
        
        XCTAssertEqual(grouped.count, 2)
        XCTAssertEqual(grouped["L"]?.first?.firstName, "Logan")
        XCTAssertEqual(grouped["M"]?.first?.firstName, "Matt")
    }
    
    func testSortedSectionKeys() {
        let friends = [
            makeUser(id: 2, firstName: "Zack", lastName: "Andrews"),
            makeUser(id: 3, firstName: "Anna", lastName: "Bell")
        ]
        
        let viewModel = FriendsListViewModel()
        let keys = viewModel.sortedSectionKeys(from: friends)
        
        XCTAssertEqual(keys, ["A", "Z"])
    }
    
    // MARK: - Toggle
    
    func testToggledSelection() {
        let viewModel = FriendsListViewModel()
        
        // When ID is not present it should be added
        let startSet: Set<Int> = [1, 2]
        let addedSelection = viewModel.toggledSelection(for: 3, in: startSet)
        XCTAssertEqual(addedSelection, [1, 2, 3])
        
        // When ID is present it should be removed
        let removedSelection = viewModel.toggledSelection(for: 2, in: addedSelection)
        XCTAssertEqual(removedSelection, [1, 3])
    }
}
