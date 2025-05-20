//
//  EventsGroupedListViewUITests.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 5/19/25.
//

import XCTest

final class EventsGroupedListViewUITests: GatherlyUITestCase {

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        app.tabBars.buttons["Calendar"].tap()
        app.buttons["toggleCalendarViewButton"].tap()
    }

    func testEventSectionsExist() {
        let knownDateLabel = "May 19, 2025" // update based on seeded data
        let sectionHeader = app.staticTexts["sectionHeader-\(knownDateLabel)"]
        XCTAssertTrue(sectionHeader.waitForExistence(timeout: 2))
    }

    func testCanTapEventRow() {
        let eventTitle = "Event 1 Today" // update to match seeded title
        let eventRow = app.buttons["eventRow-\(eventTitle)"]
        XCTAssertTrue(eventRow.waitForExistence(timeout: 2))
        eventRow.tap()

        // optional assert event detail view is shown
        let navBar = app.navigationBars[eventTitle]
        XCTAssertTrue(navBar.waitForExistence(timeout: 2))
    }
}
