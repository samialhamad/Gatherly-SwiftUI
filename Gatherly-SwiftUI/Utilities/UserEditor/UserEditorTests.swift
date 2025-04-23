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
            bannerImageName: nil,
            firstName: "Old",
            id: id,
            imageName: nil,
            lastName: "Name"
        )
    }
    
    func test_saveUser_updatesNameCorrectly() {
        let original = makeSampleUser()
        let users = [original]
        
        let updated = UserEditor.saveUser(
            originalUser: original,
            firstName: "New",
            lastName: "User",
            existingUsers: users
        )
        
        XCTAssertEqual(updated.count, 1)
        XCTAssertEqual(updated.first?.firstName, "New")
        XCTAssertEqual(updated.first?.lastName, "User")
    }
    
    func test_saveUser_updatesAvatarAndBanner() {
        let original = makeSampleUser()
        let users = [original]
        
        let updated = UserEditor.saveUser(
            originalUser: original,
            firstName: "New",
            lastName: "User",
            avatarImageName: "avatar123.png",
            bannerImageName: "banner123.png",
            existingUsers: users
        )
        
        let updatedUser = updated.first
        XCTAssertEqual(updatedUser?.imageName, "avatar123.png")
        XCTAssertEqual(updatedUser?.bannerImageName, "banner123.png")
    }
    
    func test_saveUser_appendsIfUserNotFound() {
        let existing = makeSampleUser(id: 99) // Different user
        let newUser = makeSampleUser(id: 1)
        
        let updated = UserEditor.saveUser(
            originalUser: newUser,
            firstName: "Added",
            lastName: "User",
            existingUsers: [existing]
        )
        
        XCTAssertEqual(updated.count, 2)
        XCTAssertTrue(updated.contains(where: { $0.id == 1 }))
    }
}
