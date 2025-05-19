//
//  CalendarView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 5/19/25.
//

import XCTest

final class CalendarViewUITests: XCTestCase {

    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
        app.tabBars.buttons["Calendar"].tap()
    }

    func testShowsMyEventsTitleOnLaunch() {
        XCTAssertTrue(app.navigationBars["My Events"].waitForExistence(timeout: 2))
    }

    func testToggleCalendarListButtonWorks() {
        let toggleButton = app.buttons["toggleCalendarViewButton"]
        XCTAssertTrue(toggleButton.exists)

        toggleButton.tap() // tap to switch to list mode
        toggleButton.tap() // switch back
    }

    func testViewEventsForDateNavigatesToDayEvents() {
        let viewEventsButton = app.buttons.containing(NSPredicate(format: "label CONTAINS 'View Events for'")).firstMatch

        if viewEventsButton.waitForExistence(timeout: 3) {
            viewEventsButton.tap()
            XCTAssertTrue(app.navigationBars.element.staticTexts.firstMatch.label.contains("2025"))
        } else {
            XCTFail("View Events for date button not found")
        }
    }
}
