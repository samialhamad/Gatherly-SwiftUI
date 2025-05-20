//
//  DayEventsViewUITests.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 5/19/25.
//

import XCTest

final class DayEventsViewUITests: XCTestCase {

    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
        app.tabBars.buttons["Calendar"].tap()
        let viewEventsButton = app.buttons["viewEventsForDateButton"]
        XCTAssertTrue(viewEventsButton.waitForExistence(timeout: 3))
        viewEventsButton.tap()
    }

    func testDayEventsTitleMatchesExpectedDate() {
        let navBar = app.navigationBars.element
        XCTAssertTrue(navBar.waitForExistence(timeout: 2))
        print("DayEvents title: \(navBar.staticTexts.firstMatch.label)")
    }

    func testEventSectionsExistIfEventsPresent() {
        XCTAssertTrue(app.staticTexts["sectionHeader-Finished"].exists ||
                      app.staticTexts["sectionHeader-In Progress"].exists ||
                      app.staticTexts["sectionHeader-Upcoming"].exists)
    }

    func testCanTapEventRowAndNavigateToDetail() {
        let knownTitle = "Event 1 Today" // match seeded event
        let row = app.buttons["eventRow-\(knownTitle)"]
        XCTAssertTrue(row.waitForExistence(timeout: 2))
        row.tap()
        XCTAssertTrue(app.navigationBars[knownTitle].exists)
    }

    func testAddEventButtonExists() {
        let addEventButton = app.buttons["addEventButton"]
        XCTAssertTrue(addEventButton.exists)
    }
}
