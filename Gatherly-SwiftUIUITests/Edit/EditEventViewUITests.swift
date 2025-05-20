//
//  EditEventViewUITests.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 5/20/25.
//

import XCTest

final class EditEventViewUITests: GatherlyUITestCase {

    override func setUpWithError() throws {
        try super.setUpWithError()

        app.tabBars.buttons["Calendar"].tap()
        let viewEventsButton = app.buttons["viewEventsForDateButton"]
        XCTAssertTrue(viewEventsButton.waitForExistence(timeout: 3))
        viewEventsButton.tap()

        let eventRow = app.buttons["eventRow-Event 3 Today"]
        XCTAssertTrue(eventRow.waitForExistence(timeout: 3))
        eventRow.tap()

        let editButton = app.buttons["Edit"]
        XCTAssertTrue(editButton.waitForExistence(timeout: 2))
        editButton.tap()
    }

    func testEditEventViewLoads() {
        XCTAssertTrue(app.navigationBars["Edit Event"].waitForExistence(timeout: 2))
    }

    func testEditingTitleEnablesSaveButton() {
        let titleField = app.textFields["eventTitleTextField"]
        XCTAssertTrue(titleField.waitForExistence(timeout: 2))
        XCTAssertTrue(titleField.isHittable)

        titleField.tap()
        titleField.clearAndEnterText("Updated Event Title")

        let saveButton = app.buttons["saveEventButton"]
        XCTAssertTrue(saveButton.waitForExistence(timeout: 2))
        XCTAssertTrue(saveButton.isEnabled)
    }

    func testDeleteButtonShowsConfirmationDialog() {
        let deleteButton = app.buttons["deleteEventButton"]
        app.swipeUp()
        XCTAssertTrue(deleteButton.waitForExistence(timeout: 2))
        deleteButton.tap()

        let alert = app.alerts["Delete Event?"]
        XCTAssertTrue(alert.waitForExistence(timeout: 2))
        XCTAssertTrue(alert.buttons["Delete"].exists)
        XCTAssertTrue(alert.buttons["Cancel"].exists)
    }
}
