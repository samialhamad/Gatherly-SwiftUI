//
//  FriendsListViewUITests.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 5/19/25.
//

import XCTest

final class FriendsListViewUITests: GatherlyUITestCase {

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        app.tabBars.buttons["Friends"].tap()
    }
    
    func testFriendsAreListedAlphabetically() {
        // Assuming friends list is in default order with no search applied
        XCTAssertTrue(app.buttons["friendRow-Bob"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.buttons["friendRow-Charlie"].exists)
        app.swipeUp()
        XCTAssertTrue(app.buttons["friendRow-Zebra"].exists)
    }

    func testCanTapFriendRowToNavigateToUserDetail() {
        let bobRow = app.buttons["friendRow-Bob"]
        XCTAssertTrue(bobRow.waitForExistence(timeout: 2))
        bobRow.tap()

        let navTitle = app.navigationBars["Bob Jones"]
        XCTAssertTrue(navTitle.waitForExistence(timeout: 2))
    }
    
    // MARK: - Edit Friend
    
    func testEditingFriendUpdatesName() {
        let oldFirstName = "Bob"
        let oldRow = app.buttons["friendRow-\(oldFirstName)"]
        let newFirstName = "Chocolate"
        let newLastName = "Banana"
        let updatedFullName = "\(newFirstName) \(newLastName)"

        XCTAssertTrue(oldRow.waitForExistence(timeout: 2))
        oldRow.tap()

        let actionButton = app.buttons["userDetailOptionsButton"]
        XCTAssertTrue(actionButton.waitForExistence(timeout: 2))
        actionButton.tap()

        let editButton = app.buttons["Edit"]
        XCTAssertTrue(editButton.waitForExistence(timeout: 2))
        editButton.tap()

        let firstNameField = app.textFields["userFormFirstName"]
        XCTAssertTrue(firstNameField.waitForExistence(timeout: 2))
        firstNameField.tap()
        firstNameField.clearAndEnterText(newFirstName)

        let lastNameField = app.textFields["userFormLastName"]
        XCTAssertTrue(lastNameField.exists)
        lastNameField.tap()
        lastNameField.clearAndEnterText(newLastName)

        app.navigationBars["Edit Friend"].tap()
        let saveButton = app.buttons["userFormSaveButton"]
        XCTAssertTrue(saveButton.exists)
        saveButton.tap()
        
        let userDetailNavBar = app.navigationBars[updatedFullName]
        XCTAssertTrue(userDetailNavBar.waitForExistence(timeout: 3))
        
        // Tap back to return to Friends list
        app.navigationBars.buttons.element(boundBy: 0).tap()

        let friendsNavBar = app.navigationBars["Friends"]
        XCTAssertTrue(friendsNavBar.waitForExistence(timeout: 3))

        let updatedRow = app.staticTexts[updatedFullName]
        XCTAssertTrue(updatedRow.waitForExistence(timeout: 3))
    }
    
    // MARK: - Remove Friend
    
    func testRemovingFriendRemovesFromList() {
        let friendName = "Bob"
        let friendRow = app.buttons["friendRow-\(friendName)"]

        XCTAssertTrue(friendRow.waitForExistence(timeout: 2))
        friendRow.tap()

        let actionButton = app.buttons["userDetailOptionsButton"]
        XCTAssertTrue(actionButton.waitForExistence(timeout: 2))
        actionButton.tap()

        let removeButton = app.buttons["Remove Friend"]
        XCTAssertTrue(removeButton.waitForExistence(timeout: 2))
        removeButton.tap()

        let navBar = app.navigationBars["Friends"]
        XCTAssertTrue(navBar.waitForExistence(timeout: 3))

        XCTAssertFalse(friendRow.exists)
    }
}
