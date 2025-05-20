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
        XCTAssertTrue(app.buttons["groupRow-Group Sami Leads"].waitForExistence(timeout: 2))
        XCTAssertTrue(app.buttons["groupRow-Group I'm a Member in"].exists)
    }

    func testTappingGroupNavigatesToDetail() {
        let groupRow = app.buttons["groupRow-Group Sami Leads"]
        XCTAssertTrue(groupRow.waitForExistence(timeout: 2))
        groupRow.tap()

        let navBar = app.navigationBars["Group Sami Leads"]
        XCTAssertTrue(navBar.waitForExistence(timeout: 2))
    }
}
