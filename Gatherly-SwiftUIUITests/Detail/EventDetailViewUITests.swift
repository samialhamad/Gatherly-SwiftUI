//
//  EventDetailViewUITests.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 5/19/25.
//

import XCTest

final class EventDetailViewUITests: XCTestCase {

    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
        app.tabBars.buttons["Calendar"].tap()

        let viewEventsButton = app.buttons["viewEventsForDateButton"]
        XCTAssertTrue(viewEventsButton.waitForExistence(timeout: 3))
        viewEventsButton.tap()

        let eventRow = app.buttons["eventRow-Event 2 Today"]
        XCTAssertTrue(eventRow.waitForExistence(timeout: 3))
        eventRow.tap()
    }

    func testEventDetailTitleAppears() {
        let navBar = app.navigationBars["Event 2 Today"]
        XCTAssertTrue(navBar.waitForExistence(timeout: 2))
    }

    func testDescriptionIsVisible() {
        let longTextPrefix = "Event 2 for today"
        let descriptionText = app.staticTexts.containing(NSPredicate(format: "label BEGINSWITH %@", longTextPrefix)).firstMatch
        XCTAssertTrue(descriptionText.waitForExistence(timeout: 2))
    }

    func testDateAndTimeTextExist() {
        XCTAssertTrue(app.staticTexts.containing(NSPredicate(format: "label BEGINSWITH 'Date:'")).firstMatch.exists)
        XCTAssertTrue(app.staticTexts.containing(NSPredicate(format: "label BEGINSWITH 'Time:'")).firstMatch.exists)
    }

    func testPlannerAndAttendeesSectionsExist() {
        XCTAssertTrue(app.staticTexts["Planner"].exists)
        XCTAssertTrue(app.staticTexts["Attendees"].exists)
    }

    func testLocationAppearsOnMap() {
        let locationLabel = app.staticTexts["New York"] // name from SampleData
        XCTAssertTrue(locationLabel.waitForExistence(timeout: 2))
    }
}
