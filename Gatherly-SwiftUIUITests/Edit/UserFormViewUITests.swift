//
//  UserFormViewUITests.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 5/20/25.
//

import XCTest

final class UserFormViewUITests: GatherlyUITestCase {

    override func setUpWithError() throws {
        try super.setUpWithError()
        app.tabBars.buttons["Friends"].tap()
        app.navigationBars.buttons["Add"].tap()
    }

    func testUserFormViewLoads() {
        XCTAssertTrue(app.navigationBars["New Friend"].waitForExistence(timeout: 2))
    }

    // MARK: - Save Button
    
    func testSaveDisabledIfFirstNameIsEmpty() {
        let firstNameField = app.textFields["userFormFirstName"]
        let saveButton = app.buttons["userFormSaveButton"]

        XCTAssertTrue(firstNameField.waitForExistence(timeout: 2))
        firstNameField.tap()
        firstNameField.clearAndEnterText("")

        app.navigationBars["New Friend"].tap() // dismiss keyboard
        XCTAssertFalse(saveButton.isEnabled)
    }

    func testSaveEnabledIfFirstNameIsEntered() {
        let firstNameField = app.textFields["userFormFirstName"]
        let lastNameField = app.textFields["userFormLastName"]
        let saveButton = app.buttons["userFormSaveButton"]

        XCTAssertTrue(firstNameField.waitForExistence(timeout: 2))
        firstNameField.tap()
        firstNameField.clearAndEnterText("LeBron")

        lastNameField.tap()
        lastNameField.clearAndEnterText("James")

        app.navigationBars["New Friend"].tap()
        XCTAssertTrue(saveButton.isEnabled)
    }
    
    // MARK: - Saving New Friend

    func testSaveAddsNewFriend() {
        let firstNameField = app.textFields["userFormFirstName"]
        let lastNameField = app.textFields["userFormLastName"]

        firstNameField.tap()
        firstNameField.clearAndEnterText("LeBron")

        lastNameField.tap()
        lastNameField.clearAndEnterText("James")

        app.navigationBars["New Friend"].tap()
        app.buttons["userFormSaveButton"].tap()

        // Verify we're back on Friends tab and new friend appears
        let newFriendRow = app.staticTexts["LeBron James"]
        XCTAssertTrue(newFriendRow.waitForExistence(timeout: 3))
    }
}
