//
//  EventDetailViewUITests.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 5/19/25.
//

import XCTest

final class EventDetailViewUITests: GatherlyUITestCase {
        
    override func setUpWithError() throws {
        try super.setUpWithError()
        
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
        let dateLabel = app.staticTexts.containing(NSPredicate(format: "label BEGINSWITH 'Date:'")).firstMatch
        let timeLabel = app.staticTexts.containing(NSPredicate(format: "label BEGINSWITH 'Time:'")).firstMatch
        
        XCTAssertTrue(dateLabel.waitForExistence(timeout: 5))
        XCTAssertTrue(timeLabel.waitForExistence(timeout: 5))
    }
    
    func testPlannerAndAttendeesSectionsExist() {
        let plannerLabel = app.staticTexts["Planner"]
        let attendeesLabel = app.staticTexts["Attendees"]
        
        XCTAssertTrue(plannerLabel.waitForExistence(timeout: 5))
        XCTAssertTrue(attendeesLabel.waitForExistence(timeout: 5))
    }
    
    func testLocationAppearsOnMap() {
        let locationLabel = app.staticTexts["New York"] // name from SampleData
        XCTAssertTrue(locationLabel.waitForExistence(timeout: 2))
    }
}
