//
//  CreateEventViewUITests.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 5/19/25.
//

import Foundation
import XCTest

final class CreateEventViewUITests: GatherlyUITestCase {
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        app.tabBars.buttons["Create"].tap()
    }
    
    // MARK: - Create Button
    
    func testCreateButtonIsDisabledInitially() {
        let createButton = app.buttons["createEventButton"]
        app.swipeUp()
        XCTAssertTrue(createButton.waitForExistence(timeout: 2))
        XCTAssertFalse(createButton.isEnabled)
    }
    
    func testEnteringRequiredFieldsEnablesCreateButton() {
        let titleField = app.textFields["eventTitleTextField"]
        XCTAssertTrue(titleField.waitForExistence(timeout: 2))
        titleField.tap()
        titleField.typeText("UI Test Event")
        
        // Dismiss keyboard before trying to swipe
        app.navigationBars["Create Event"].tap()
        
        app.swipeUp()
        let createButton = app.buttons["createEventButton"]
        XCTAssertTrue(createButton.waitForExistence(timeout: 2))
        XCTAssertTrue(createButton.isEnabled)
    }
    
    func testSuccessfulCreateNavigatesAway() {
        let titleField = app.textFields["eventTitleTextField"]
        XCTAssertTrue(titleField.waitForExistence(timeout: 2))
        titleField.tap()
        titleField.typeText("UI Test Event")
        
        app.navigationBars["Create Event"].tap()
        
        app.swipeUp()
        let createButton = app.buttons["createEventButton"]
        XCTAssertTrue(createButton.waitForExistence(timeout: 2))
        XCTAssertTrue(createButton.isEnabled)
        createButton.tap()
        
        // Verify that it navigated away to EventDetailView (based on navigation title)
        let navBar = app.navigationBars["UI Test Event"]
        XCTAssertTrue(navBar.waitForExistence(timeout: 5))
    }
    
    func testSuccessfulCreateNavigatesAway_backNavigatesToDayEventsView_andBackToCalendarView() {
        let titleField = app.textFields["eventTitleTextField"]
        XCTAssertTrue(titleField.waitForExistence(timeout: 2))
        titleField.tap()
        titleField.typeText("UI Test Event")
        
        app.navigationBars["Create Event"].tap()
        
        app.swipeUp()
        let createButton = app.buttons["createEventButton"]
        XCTAssertTrue(createButton.waitForExistence(timeout: 2))
        XCTAssertTrue(createButton.isEnabled)
        createButton.tap()
        
        let detailNavBar = app.navigationBars["UI Test Event"]
        XCTAssertTrue(detailNavBar.waitForExistence(timeout: 7))
        
        let backButton = detailNavBar.buttons.firstMatch
        XCTAssertTrue(backButton.exists)
        backButton.tap()
        
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        let todayString = formatter.string(from: Date())
        
        let dayNavBar = app.navigationBars[todayString]
        XCTAssertTrue(dayNavBar.waitForExistence(timeout: 2))
        
        let dayBackButton = dayNavBar.buttons.firstMatch
        XCTAssertTrue(dayBackButton.exists)
        dayBackButton.tap()
        
        let calendarNavBar = app.navigationBars["My Events"]
        XCTAssertTrue(calendarNavBar.waitForExistence(timeout: 2))
        XCTAssertFalse(app.buttons["resetToTodayButton"].exists)
    }
    
    // MARK: - Text Field Tests
    
    func testTitleFieldAcceptsInput() {
        let titleField = app.textFields["eventTitleTextField"]
        XCTAssertTrue(titleField.waitForExistence(timeout: 2))
        titleField.tap()
        titleField.typeText("Team Planning Meeting")
        XCTAssertEqual(titleField.value as? String, "Team Planning Meeting")
    }
    
    func testDescriptionFieldAcceptsMultilineInput() {
        let descriptionField = app.textFields["eventDescriptionTextField"]
        XCTAssertTrue(descriptionField.waitForExistence(timeout: 2))
        descriptionField.tap()
        descriptionField.typeText("This is a multiline\ndescription for the event.")
        XCTAssertTrue((descriptionField.value as? String)?.contains("This is a multiline") == true)
    }
    
    func testLocationFieldAcceptsInput() {
        let locationField = app.textFields["eventLocationTextField"]
        XCTAssertTrue(locationField.waitForExistence(timeout: 2))
        locationField.tap()
        locationField.typeText("San Francisco HQ")
        XCTAssertEqual(locationField.value as? String, "San Francisco HQ")
    }
    
    // MARK: - Picker and Sheet Interaction
    
    func testInviteFriendsPickerOpens() {
        let inviteButton = app.buttons["inviteFriendsButton"]
        XCTAssertTrue(inviteButton.waitForExistence(timeout: 2))
        inviteButton.tap()
        
        // Check if sheet opens via "Done" button
        let doneButton = app.buttons["Done"]
        XCTAssertTrue(doneButton.waitForExistence(timeout: 2))
        doneButton.tap()
    }
    
    func testCategoryPickerOpens() {
        let categoryButton = app.buttons["categoryPickerButton"]
        XCTAssertTrue(categoryButton.waitForExistence(timeout: 2))
        categoryButton.tap()
        
        // Check if sheet opens via "Done" button
        let doneButton = app.buttons["Done"]
        XCTAssertTrue(doneButton.waitForExistence(timeout: 2))
        doneButton.tap()
    }
    
    // MARK: - Date/Time Pickers
    
    func testEventDatePickerIsPresent() {
        let datePicker = app.descendants(matching: .any)["eventDatePicker"]
        XCTAssertTrue(datePicker.waitForExistence(timeout: 2))
    }
    
    func testStartTimePickerIsPresent() {
        let startPicker = app.descendants(matching: .any)["startTimePicker"]
        XCTAssertTrue(startPicker.waitForExistence(timeout: 2))
    }
    
    func testEndTimePickerIsPresent() {
        let endPicker = app.descendants(matching: .any)["endTimePicker"]
        XCTAssertTrue(endPicker.waitForExistence(timeout: 2))
    }
}
