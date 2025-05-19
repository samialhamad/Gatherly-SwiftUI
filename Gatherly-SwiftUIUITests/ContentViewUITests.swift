//
//  ContentViewUITests.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 5/19/25.
//

import XCTest

final class ContentViewUITests: XCTestCase {
    
    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }

    func testTabBarButtonsExist() {
        XCTAssertTrue(app.tabBars.buttons["Calendar"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.tabBars.buttons["Create"].exists)
        XCTAssertTrue(app.tabBars.buttons["Friends"].exists)
        XCTAssertTrue(app.tabBars.buttons["Profile"].exists)
    }

    func testCanSwitchBetweenTabs() {
        let calendarTab = app.tabBars.buttons["Calendar"]
        let createTab = app.tabBars.buttons["Create"]
        let friendsTab = app.tabBars.buttons["Friends"]
        let profileTab = app.tabBars.buttons["Profile"]

        createTab.tap()
        XCTAssertTrue(app.navigationBars["Create Event"].waitForExistence(timeout: 2))

        friendsTab.tap()
        XCTAssertTrue(app.navigationBars["Friends"].waitForExistence(timeout: 2))

        profileTab.tap()
        XCTAssertTrue(app.navigationBars.element.waitForExistence(timeout: 2))
    }
}
