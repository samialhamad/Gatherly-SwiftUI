//
//  GroupDetailViewUITests.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 5/19/25.
//

import XCTest

final class GroupDetailViewUITests: GatherlyUITestCase {
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        app.tabBars.buttons["Friends"].tap()
        app.segmentedControls.buttons["Groups"].tap()
        
        let groupRow = app.buttons["groupRow-Work Buddies"] // Relies on SampleData group
        XCTAssertTrue(groupRow.waitForExistence(timeout: 2))
        groupRow.tap()
    }
    
    func testGroupNameAppearsInTitle() {
        let navBar = app.navigationBars["Work Buddies"]
        XCTAssertTrue(navBar.waitForExistence(timeout: 2))
    }
    
    func testEditButtonAppearsForLeader() {
        let editButton = app.buttons["editGroupButton"]
        XCTAssertTrue(editButton.exists)
    }
    
    func testLeaderAndMemberSectionsAreVisible() {
        XCTAssertTrue(app.staticTexts["Leader"].exists)
        XCTAssertTrue(app.staticTexts["Members"].exists)
        XCTAssertTrue(app.staticTexts["Charlie Brown"].exists) // relies on Charlie being in this group still via SampleData
    }
    
    func testTappingMemberNavigatesToUserDetail() {
        let memberRow = app.buttons["groupMemberRow-Charlie"]
        XCTAssertTrue(memberRow.exists)
        memberRow.tap()
        
        let userDetailNav = app.navigationBars["Charlie Brown"]
        XCTAssertTrue(userDetailNav.waitForExistence(timeout: 2))
    }
}
