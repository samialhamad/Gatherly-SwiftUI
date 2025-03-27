//
//  FriendsListViewTests.swift
//  Gatherly-SwiftUITests
//
//  Created by Sami Alhamad on 3/27/25.
//

import XCTest
@testable import Gatherly_SwiftUI

final class FriendsListViewModelTests: XCTestCase {

    func testFriends() {
        let currentUser = User(firstName: "Current", friendIDs: [2, 3], id: 1, lastName: "User")
        let friend1 = User(firstName: "Friend", friendIDs: nil, id: 2, lastName: "One")
        let friend2 = User(firstName: "Friend", friendIDs: nil, id: 3, lastName: "Two")
        let nonFriend = User(firstName: "Non", friendIDs: nil, id: 4, lastName: "Friend")
        let allUsers = [currentUser, friend1, friend2, nonFriend]

        let viewModel = FriendsListViewModel(currentUserID: 1, allUsers: allUsers)
        let friends = viewModel.friends
        
        XCTAssertEqual(friends.count, 2)
        XCTAssertTrue(friends.contains { $0.id == 2 })
        XCTAssertTrue(friends.contains { $0.id == 3 })
        XCTAssertFalse(friends.contains { $0.id == 4 })
    }
    
    func testFilteredFriends() {
        let currentUser = User(firstName: "Current", friendIDs: [2, 3], id: 1, lastName: "User")
        let friend1 = User(firstName: "Friend", friendIDs: nil, id: 2, lastName: "One")
        let friend2 = User(firstName: "Friend", friendIDs: nil, id: 3, lastName: "Two")
        let nonFriend = User(firstName: "Non", friendIDs: nil, id: 4, lastName: "Friend")
        let allUsers = [currentUser, friend1, friend2, nonFriend]

        let viewModel = FriendsListViewModel(currentUserID: 1, allUsers: allUsers)
        
        viewModel.searchText = "two"
        let filtered = viewModel.filteredFriends

        XCTAssertEqual(filtered.count, 1)
        XCTAssertEqual(filtered.first?.lastName, "Two")
    }

    func testGroupedFriends() {
        let currentUser = User(firstName: "Current", friendIDs: [2, 3], id: 1, lastName: "User")
        let friend1 = User(firstName: "Matt", friendIDs: nil, id: 2, lastName: "Simon")
        let friend2 = User(firstName: "Logan", friendIDs: nil, id: 3, lastName: "Harrison")
        let allUsers = [currentUser, friend1, friend2]

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
        let currentUser = User(firstName: "Current", friendIDs: [2, 3], id: 1, lastName: "User")
        let friend1 = User(firstName: "Zack", friendIDs: nil, id: 2, lastName: "Andrews")
        let friend2 = User(firstName: "Anna", friendIDs: nil, id: 3, lastName: "Bell")
        let allUsers = [currentUser, friend1, friend2]

        let viewModel = FriendsListViewModel(currentUserID: 1, allUsers: allUsers)
        
        let sectionKeys = viewModel.sortedSectionKeys
        
        XCTAssertEqual(sectionKeys, ["A", "Z"])
    }
}
