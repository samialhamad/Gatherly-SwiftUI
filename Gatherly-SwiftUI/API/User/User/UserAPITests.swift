//
//  UserAPITests.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 5/7/25.
//

import XCTest
@testable import Gatherly_SwiftUI

final class UserAPITests: XCTestCase {

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
    
    // MARK: - Creating Users

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
    
    // MARK: - Updating Users

    func testUpdateUser_updatesNameCorrectly() async {
        let original = makeSampleUser(id: 1)
        UserDefaultsManager.saveUsers([original])

        let updated = await GatherlyAPI.updateUser(
            original,
            firstName: "New",
            lastName: "User"
        )

        XCTAssertEqual(updated.firstName, "New")
        XCTAssertEqual(updated.lastName, "User")
    }

    func testUpdateUser_updatesAvatarAndBanner() async {
        let original = makeSampleUser(id: 1)
        UserDefaultsManager.saveUsers([original])

        let updated = await GatherlyAPI.updateUser(
            original,
            firstName: "New",
            lastName: "User",
            avatarImageName: "avatar123.png",
            bannerImageName: "banner123.png"
        )

        XCTAssertEqual(updated.avatarImageName, "avatar123.png")
        XCTAssertEqual(updated.bannerImageName, "banner123.png")
    }
}
