//
//  UserEditorTests.swift
//  Gatherly-SwiftUITests
//
//  Created by Sami Alhamad on 4/22/25.
//

import XCTest
@testable import Gatherly_SwiftUI

final class UserEditorTests: XCTestCase {
    
    func makeSampleUser(id: Int = 1) -> User {
        User(
            avatarImageName: nil,
            bannerImageName: nil,
            firstName: "Old",
            id: id,
            lastName: "Name"
        )
    }
    
    func testSaveUser_updatesNameCorrectly() {
        let original = makeSampleUser()
        
        let updatedUser = UserEditor.saveUser(
            user: original,
            firstName: "New",
            lastName: "User"
        )
        
        XCTAssertEqual(updatedUser.firstName, "New")
        XCTAssertEqual(updatedUser.lastName, "User")
    }
    
    func testSaveUser_updatesAvatarAndBanner() {
        let original = makeSampleUser()
        
        let updatedUser = UserEditor.saveUser(
            user: original,
            firstName: "New",
            lastName: "User",
            avatarImageName: "avatar123.png",
            bannerImageName: "banner123.png"
        )
        
        XCTAssertEqual(updatedUser.avatarImageName, "avatar123.png")
        XCTAssertEqual(updatedUser.bannerImageName, "banner123.png")
    }
}
