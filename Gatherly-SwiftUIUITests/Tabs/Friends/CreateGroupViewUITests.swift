//
//  CreateGroupViewUITests.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 5/19/25.
//

import XCTest

final class CreateGroupViewUITests: GatherlyUITestCase {
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        app.tabBars.buttons["Friends"].tap()
        app.segmentedControls.buttons["Groups"].tap()
        app.buttons["addFriendOrGroupButton"].tap()
    }

    func testGroupNameFieldAcceptsInput() {
        let groupNameField = app.textFields["groupNameTextField"]
        XCTAssertTrue(groupNameField.waitForExistence(timeout: 2))
        
        groupNameField.tap()
        groupNameField.typeText("UI Test Group")
        
        XCTAssertEqual(groupNameField.value as? String, "UI Test Group")
    }

    func testInviteFriendsButtonOpensPicker() {
        let inviteButton = app.buttons["inviteFriendsButton"]
        XCTAssertTrue(inviteButton.waitForExistence(timeout: 2))
        inviteButton.tap()

        let doneButton = app.buttons["Done"]
        XCTAssertTrue(doneButton.waitForExistence(timeout: 2))
        doneButton.tap()
    }

    func testCreateButtonDisabledInitially() {
        let createButton = app.buttons["createGroupButton"]
        XCTAssertTrue(createButton.waitForExistence(timeout: 2))
        XCTAssertFalse(createButton.isEnabled)
    }
}
