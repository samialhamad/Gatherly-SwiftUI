//
//  ProfileViewUITests.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 5/19/25.
//

import XCTest

final class ProfileViewUITests: GatherlyUITestCase {
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        app.tabBars.buttons["Profile"].tap()
    }

    func testProfileTitleAppears() {
        let expectedName = "Sami Alhamad" // match sample user name
        let navBar = app.navigationBars[expectedName]
        XCTAssertTrue(navBar.waitForExistence(timeout: 3))
    }
    
    // MARK: - Edit Profile

    func testEditProfileButtonOpensForm() {
        let editButton = app.buttons["editProfileButton"]
        XCTAssertTrue(editButton.exists)
        editButton.tap()

        // UserFormView sheet opens with "First Name" field
        let firstNameField = app.textFields["First Name"]
        XCTAssertTrue(firstNameField.waitForExistence(timeout: 2))
    }
    
    func testEditingProfileNameUpdatesNavTitle() {
        let originalName = "Sami Alhamad"
        let updatedFirstName = "New"
        let updatedLastName = "Name"
        let updatedFullName = "\(updatedFirstName) \(updatedLastName)"

        let editButton = app.buttons["editProfileButton"]
        XCTAssertTrue(editButton.waitForExistence(timeout: 2))
        editButton.tap()

        let firstNameField = app.textFields["userFormFirstName"]
        XCTAssertTrue(firstNameField.waitForExistence(timeout: 2))
        firstNameField.tap()
        firstNameField.clearAndEnterText(updatedFirstName)

        let lastNameField = app.textFields["userFormLastName"]
        XCTAssertTrue(lastNameField.waitForExistence(timeout: 2))
        lastNameField.tap()
        lastNameField.clearAndEnterText(updatedLastName)

        // Dismiss keyboard
        app.navigationBars["Edit Profile"].tap()

        let saveButton = app.buttons["userFormSaveButton"]
        XCTAssertTrue(saveButton.exists)
        saveButton.tap()

        // Wait for ProfileView to return and update
        let updatedNavBar = app.navigationBars[updatedFullName]
        XCTAssertTrue(updatedNavBar.waitForExistence(timeout: 3))
    }
    
    // MARK: - Buttons

    func testSyncContactsButtonExists() {
        let syncButton = app.buttons["syncContactsButton"]
        XCTAssertTrue(syncButton.exists)
    }

    func testLogoutAndDeleteAccountButtonsExist() {
        XCTAssertTrue(app.buttons["logoutButton"].exists)
        XCTAssertTrue(app.buttons["deleteAccountButton"].exists)
    }
}
