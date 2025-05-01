//
//  FriendsListViewTests.swift
//  Gatherly-SwiftUITests
//
//  Created by Sami Alhamad on 3/27/25.
//

import XCTest
@testable import Gatherly_SwiftUI

final class FriendsListViewModelTests: XCTestCase {
    
    func makeUser(id: Int, firstName: String, lastName: String, friendIDs: [Int]? = nil) -> User {
        User(firstName: firstName, friendIDs: friendIDs, id: id, lastName: lastName)
    }
    
    func sampleTestUsers() -> [User] {
        [
            makeUser(id: 1, firstName: "Current", lastName: "User", friendIDs: [2, 3]),
            makeUser(id: 2, firstName: "Friend", lastName: "One"),
            makeUser(id: 3, firstName: "Friend", lastName: "Two"),
            makeUser(id: 4, firstName: "Non", lastName: "Friend")
        ]
    }
    
    func testFriends() {
        let allUsers = sampleTestUsers()
        let viewModel = FriendsListViewModel(currentUserID: 1, allUsers: allUsers)
        let friends = viewModel.friends
        
        XCTAssertEqual(friends.count, 2)
        XCTAssertTrue(friends.contains { $0.id == 2 })
        XCTAssertTrue(friends.contains { $0.id == 3 })
        XCTAssertFalse(friends.contains { $0.id == 4 })
    }
    
    func testFilteredFriends() {
        let allUsers = sampleTestUsers()
        let viewModel = FriendsListViewModel(currentUserID: 1, allUsers: allUsers)
        
        viewModel.searchText = "two"
        let filtered = viewModel.filteredFriends
        
        XCTAssertEqual(filtered.count, 1)
        XCTAssertEqual(filtered.first?.lastName, "Two")
    }
    
    func testGroupedFriends() {
        let allUsers = [
            makeUser(id: 1, firstName: "Current", lastName: "User", friendIDs: [2, 3]),
            makeUser(id: 2, firstName: "Matt", lastName: "Simon"),
            makeUser(id: 3, firstName: "Logan", lastName: "Harrison")
        ]
        
        let viewModel = FriendsListViewModel(currentUserID: 1, allUsers: allUsers)
        
        viewModel.searchText = ""
        let groupedFriends = viewModel.groupedFriends
        
        XCTAssertEqual(groupedFriends.count, 2)
        XCTAssertNotNil(groupedFriends["L"])
        XCTAssertNotNil(groupedFriends["M"])
        XCTAssertEqual(groupedFriends["L"]?.first?.firstName, "Logan")
        XCTAssertEqual(groupedFriends["M"]?.first?.firstName, "Matt")
    }
    
    func testSortedSectionKeys() {
        let allUsers = [
            makeUser(id: 1, firstName: "Current", lastName: "User", friendIDs: [2, 3]),
            makeUser(id: 2, firstName: "Zack", lastName: "Andrews"),
            makeUser(id: 3, firstName: "Anna", lastName: "Bell")
        ]
        
        let viewModel = FriendsListViewModel(currentUserID: 1, allUsers: allUsers)
        let sectionKeys = viewModel.sortedSectionKeys
        
        XCTAssertEqual(sectionKeys, ["A", "Z"])
    }
}
