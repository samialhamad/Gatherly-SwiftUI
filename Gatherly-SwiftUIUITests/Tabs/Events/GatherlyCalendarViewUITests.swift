//
//  GatherlyCalendarViewUITests.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 5/19/25.
//

import XCTest

final class GatherlyCalendarViewUITests: XCTestCase {

    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
        app.tabBars.buttons["Calendar"].tap()
    }

    func testCalendarIsVisibleOnLaunch() {
        let calendar = app.otherElements["gatherlyCalendar"]
        XCTAssertTrue(calendar.waitForExistence(timeout: 2))
    }

    func testViewEventsButtonAppearsForEventDates() {
        let viewEventsButton = app.buttons["viewEventsForDateButton"]
        XCTAssertTrue(viewEventsButton.waitForExistence(timeout: 3))
    }

    func testTappingViewEventsButtonNavigatesToDayEventsView() {
        let viewEventsButton = app.buttons["viewEventsForDateButton"]
        XCTAssertTrue(viewEventsButton.waitForExistence(timeout: 3))

        viewEventsButton.tap()

        let navBarTitle = app.navigationBars.element.staticTexts.firstMatch
        XCTAssertTrue(navBarTitle.waitForExistence(timeout: 2))
    }
}
