//
//  CreateUserTests.swift
//  Gatherly-SwiftUITests
//
//  Created by Sami Alhamad on 5/8/25.
//

import XCTest
@testable import Gatherly_SwiftUI

final class CreateUserTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        UserDefaultsManager.removeUsers()
    }
    
    func makeSampleUser(id: Int = 1) -> User {
        User(
            avatarImageName: nil,
            bannerImageName: nil,
            firstName: "Old",
            id: id,
            lastName: "Name"
        )
    }
    
    func testCreateUser_incrementsIDAndPersists() async {
        let _ = await GatherlyAPI.createUser(
            firstName: "Alice",
            lastName: "One"
        )
        let secondUser = await GatherlyAPI.createUser(
            firstName: "Bob",
            lastName: "Two"
        )
        
        let allUsers = UserDefaultsManager.loadUsers()
        XCTAssertEqual(allUsers.count, 2)
        XCTAssertEqual(secondUser.id, allUsers.map { $0.id ?? 0 }.max())
    }
    
    func testCreateUserFromContact_persistsCorrectly() async {
        let contact = SyncedContact(fullName: "Charlie Example", phoneNumber: "5551234567")
        let newUser = await GatherlyAPI.createUser(from: contact, id: 99)
        
        XCTAssertEqual(newUser.id, 99)
        XCTAssertEqual(newUser.firstName, "Charlie")
        XCTAssertEqual(newUser.lastName, "Example")
        XCTAssertEqual(newUser.phone, "5551234567")
    }
}
