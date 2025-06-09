//
//  GroupsListViewUITests.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 5/19/25.
//

import XCTest

final class GroupsListViewUITests: GatherlyUITestCase {
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        app.tabBars.buttons["Friends"].tap()
        app.segmentedControls.buttons["Groups"].tap()
    }

    func testGroupsAppearInList() {
        XCTAssertTrue(app.buttons["groupRow-Work Buddies"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.buttons["groupRow-Study Group"].exists)
    }

    func testTappingGroupNavigatesToDetail() {
        let groupRow = app.buttons["groupRow-Work Buddies"]
        XCTAssertTrue(groupRow.waitForExistence(timeout: 2))
        groupRow.tap()

        let navBar = app.navigationBars["Work Buddies"]
        XCTAssertTrue(navBar.waitForExistence(timeout: 2))
    }
}
