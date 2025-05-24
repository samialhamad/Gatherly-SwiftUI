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
            createdTimestamp: Int(Date().timestamp),
            email: nil,
            eventIDs: [],
            firstName: "Old",
            friendIDs: [],
            groupIDs: [],
            id: id,
            isEmailEnabled: false,
            lastName: "Name",
            phone: nil
        )
    }
    
    func testUpdateUser_updatesNameCorrectly() async {
        var originalUser = makeSampleUser(id: 1)
        UserDefaultsManager.saveUsers([originalUser])
        
        originalUser.firstName = "New"
        originalUser.lastName = "User"
        
        let updatedUser = await GatherlyAPI.updateUser(originalUser)
        
        XCTAssertEqual(updatedUser.firstName, "New")
        XCTAssertEqual(updatedUser.lastName, "User")
    }
    
    func testUpdateUser_updatesAvatarAndBanner() async {
        var originalUser = makeSampleUser(id: 1)
        UserDefaultsManager.saveUsers([originalUser])
        
        originalUser.avatarImageName = "avatar123.png"
        originalUser.bannerImageName = "banner123.png"
        
        let updatedUser = await GatherlyAPI.updateUser(originalUser)
        
        XCTAssertEqual(updatedUser.avatarImageName, "avatar123.png")
        XCTAssertEqual(updatedUser.bannerImageName, "banner123.png")
    }
}
