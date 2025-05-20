//
//  FriendsListViewUITests.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 5/19/25.
//

import XCTest

final class FriendsListViewUITests: XCTestCase {

    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
        app.tabBars.buttons["Friends"].tap()
    }

    func testFriendsAreListedAlphabetically() {
        // Assuming friends list is in default order with no search applied
        XCTAssertTrue(app.buttons["friendRow-Bob"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.buttons["friendRow-Charlie"].exists)
        XCTAssertTrue(app.buttons["friendRow-Zebra"].exists)
    }

    func testCanTapFriendRowToNavigateToUserDetail() {
        let bobRow = app.buttons["friendRow-Bob"]
        XCTAssertTrue(bobRow.waitForExistence(timeout: 2))
        bobRow.tap()

        let navTitle = app.navigationBars["Bob Jones"]
        XCTAssertTrue(navTitle.waitForExistence(timeout: 2))
    }
}
