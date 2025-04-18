//
//  ContentViewModelTests.swift
//  Gatherly-SwiftUITests
//
//  Created by Sami Alhamad on 4/17/25.
//

import XCTest
@testable import Gatherly_SwiftUI

final class ContentViewModelTests: XCTestCase {
    
    func test_appendUsersAndUpdateFriends() {
        let viewModel = ContentViewModel()
        viewModel.users = [
            User(firstName: "Sami", friendIDs: [2], id: 1)
        ]
        
        let newUsers = [
            User(firstName: "Matt", id: 3),
            User(firstName: "Sara", id: 4)
        ]
        
        let newFriendIDs = [3, 4]
        
        viewModel.appendUsersAndUpdateFriends(newUsers: newUsers, newFriendIDs: newFriendIDs, currentUserID: 1)
        
        let currentUser = viewModel.users.first(where: { $0.id == 1 })
        
        XCTAssertEqual(viewModel.users.count, 3)
        XCTAssertEqual(Set(currentUser?.friendIDs ?? []), Set([2, 3, 4]))
    }
    
    func test_generateUsersFromContacts() {
        let viewModel = ContentViewModel()
        viewModel.users = [
            User(firstName: "Sami", id: 1, phone: "1234567890")
        ]
        
        let contacts: [SyncedContact] = [
            SyncedContact(fullName: "Bob Smith", phoneNumber: "9876543210"),
            SyncedContact(fullName: "Alice Jones", phoneNumber: "5556667777"),
            SyncedContact(fullName: "Duplicate", phoneNumber: "1234567890")
        ]
        
        let (newUsers, newFriendIDs) = viewModel.generateUsersFromContacts(contacts)
        
        XCTAssertEqual(newUsers.count, 2)
        XCTAssertEqual(newFriendIDs.count, 2)
        XCTAssertEqual(newUsers[0].firstName, "Bob")
        XCTAssertEqual(newUsers[1].firstName, "Alice")
    }
}
