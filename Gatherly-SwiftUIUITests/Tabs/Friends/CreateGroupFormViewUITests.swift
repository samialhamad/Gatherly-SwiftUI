//
//  CreateGroupFormViewUITests.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 5/19/25.
//

import XCTest

final class CreateGroupFormViewUITests: GatherlyUITestCase {
    
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
    
    func testCreateGroupNavigatesToGroupDetail() {
        let groupName = "UI Test Group"

        let nameField = app.textFields["groupNameTextField"]
        XCTAssertTrue(nameField.waitForExistence(timeout: 2))
        nameField.tap()
        nameField.typeText(groupName)

        app.navigationBars["New Group"].tap()
        let inviteButton = app.buttons["inviteFriendsButton"]
        XCTAssertTrue(inviteButton.waitForExistence(timeout: 2))
        inviteButton.tap()

        // assuming Bob from SampleData
        let firstFriendRow = app.buttons.containing(.staticText, identifier: "Bob").firstMatch
        if firstFriendRow.exists {
            firstFriendRow.tap()
        }

        let doneButton = app.buttons["Done"]
        XCTAssertTrue(doneButton.waitForExistence(timeout: 2))
        doneButton.tap()

        // Dismiss keyboard
        app.navigationBars["New Group"].tap()
        app.swipeUp()

        // Tap Create
        let createButton = app.buttons["createGroupButton"]
        XCTAssertTrue(createButton.waitForExistence(timeout: 2))
        XCTAssertTrue(createButton.isEnabled)
        createButton.tap()

        // Wait for GroupDetailView
        let newGroupNavBar = app.navigationBars[groupName]
        XCTAssertTrue(newGroupNavBar.waitForExistence(timeout: 3))
    }
}
