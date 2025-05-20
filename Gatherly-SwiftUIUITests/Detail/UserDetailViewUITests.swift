//
//  UserDetailViewUITests.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 5/19/25.
//

import XCTest

final class UserDetailViewUITests: GatherlyUITestCase {

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        app.tabBars.buttons["Friends"].tap()
        app.segmentedControls.buttons["Friends"].tap()

        let bobRow = app.buttons["friendRow-Bob"] // Relies on SampleData user
        XCTAssertTrue(bobRow.waitForExistence(timeout: 3))
        bobRow.tap()
    }
    
    func testUserNameAppearsInNavTitleAndBody() {
        let navBar = app.navigationBars["Bob Jones"]
        XCTAssertTrue(navBar.waitForExistence(timeout: 2))

        let fullName = app.staticTexts["userDetailFullName"]
        XCTAssertTrue(fullName.exists)
    }

    func testPhoneNumberIsVisible() {
        let phoneNumber = app.staticTexts["9876543210"]
        XCTAssertTrue(phoneNumber.exists)
    }

    func testOptionsButtonOpensActionSheet() {
        let optionsButton = app.buttons["userDetailOptionsButton"]
        XCTAssertTrue(optionsButton.waitForExistence(timeout: 2))
        optionsButton.tap()

        let editOption = app.buttons["Edit"]
        XCTAssertTrue(editOption.waitForExistence(timeout: 2))
    }

    func testEditOpensUserFormSheet() {
        app.buttons["userDetailOptionsButton"].tap()
        app.buttons["Edit"].tap()

        let firstNameField = app.textFields["First Name"]
        XCTAssertTrue(firstNameField.waitForExistence(timeout: 2))
    }

    func testRemoveFriendOptionExists() {
        app.buttons["userDetailOptionsButton"].tap()
        let removeButton = app.buttons["Remove Friend"]
        XCTAssertTrue(removeButton.exists)
    }
}
