//
//  ProfileViewUITests.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 5/19/25.
//

import XCTest

final class ProfileViewUITests: XCTestCase {
    
    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
        app.tabBars.buttons["Profile"].tap()
    }

    func testProfileTitleAppears() {
        let expectedName = "Sami Alhamad" // match sample user name
        let navBar = app.navigationBars[expectedName]
        XCTAssertTrue(navBar.waitForExistence(timeout: 3))
    }

    func testEditProfileButtonOpensForm() {
        let editButton = app.buttons["editProfileButton"]
        XCTAssertTrue(editButton.exists)
        editButton.tap()

        // UserFormView sheet opens with "First Name" field
        let firstNameField = app.textFields["First Name"]
        XCTAssertTrue(firstNameField.waitForExistence(timeout: 2))
    }

    func testSyncContactsButtonExists() {
        let syncButton = app.buttons["syncContactsButton"]
        XCTAssertTrue(syncButton.exists)
    }

    func testLogoutAndDeleteAccountButtonsExist() {
        XCTAssertTrue(app.buttons["logoutButton"].exists)
        XCTAssertTrue(app.buttons["deleteAccountButton"].exists)
    }
}
