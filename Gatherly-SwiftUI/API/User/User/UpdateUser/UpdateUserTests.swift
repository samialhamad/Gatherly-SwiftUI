//
//  UpdateUserTests.swift
//  Gatherly-SwiftUITests
//
//  Created by Sami Alhamad on 5/8/25.
//

import XCTest
@testable import Gatherly_SwiftUI

final class UpdateUserTests: XCTestCase {

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
