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
