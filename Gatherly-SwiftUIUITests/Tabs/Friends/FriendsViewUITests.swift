//
//  FriendsViewUITests.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 5/19/25.
//

import XCTest

final class FriendsViewUITests: XCTestCase {

    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
        app.tabBars.buttons["Friends"].tap()
    }

    func testInitialTitleIsFriends() {
        XCTAssertTrue(app.navigationBars["Friends"].waitForExistence(timeout: 2))
    }

    func testSwitchToGroupsTabChangesTitle() {
        let groupsSegment = app.segmentedControls.buttons["Groups"]
        XCTAssertTrue(groupsSegment.waitForExistence(timeout: 2))
        groupsSegment.tap()

        XCTAssertTrue(app.navigationBars["Groups"].waitForExistence(timeout: 2))
    }

    func testAddFriendSheetAppearsInFriendsTab() {
        let friendsSegment = app.segmentedControls.buttons["Friends"]
        if friendsSegment.exists {
            friendsSegment.tap()
        }

        app.buttons["addFriendOrGroupButton"].tap()

        let firstNameField = app.textFields["First Name"]
        XCTAssertTrue(firstNameField.waitForExistence(timeout: 3))
    }

    func testAddGroupSheetAppearsInGroupsTab() {
        app.segmentedControls.buttons["Groups"].tap()
        app.buttons["addFriendOrGroupButton"].tap()

        let groupTitleField = app.textFields["Enter group name"]
        XCTAssertTrue(groupTitleField.waitForExistence(timeout: 3))
    }
}
