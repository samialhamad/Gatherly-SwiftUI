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
    
    func testFilteredFriends() {
        let viewModel = FriendsListViewModel()
        let searchText = "two"
        
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
}
