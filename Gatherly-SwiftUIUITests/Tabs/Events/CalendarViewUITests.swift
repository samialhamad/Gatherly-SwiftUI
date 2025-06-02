//
//  CalendarView.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 5/19/25.
//

import XCTest

final class CalendarViewUITests: GatherlyUITestCase {
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
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
    
    func testResetButton_notVisible_whenDateIsToday() {
        let resetButton = app.buttons["resetToTodayButton"]
        XCTAssertFalse(resetButton.exists)
    }
    
    func testResetButton_visible_whenDateIsNotToday() {
        let calendarContainer = app.otherElements["gatherlyCalendar"]
        XCTAssertTrue(calendarContainer.waitForExistence(timeout: 2))
        
        let now = Date()
        let calendar = Calendar.current
        guard let future = calendar.date(byAdding: .day, value: 2, to: now) else {
            XCTFail("Unable to compute future date.")
            return
        }
        
        if !calendar.isDate(future, equalTo: now, toGranularity: .month) {
            let nextMonthButton = calendarContainer.buttons["Next Month"]
            XCTAssertTrue(nextMonthButton.waitForExistence(timeout: 2))
            nextMonthButton.tap()
            sleep(1)
        }
        
        let monthDayFormatter = DateFormatter()
        monthDayFormatter.dateFormat = "MMMM d"
        let monthDayString = monthDayFormatter.string(from: future)
        
        let predicate = NSPredicate(format: "label CONTAINS[c] %@", monthDayString)
        let futureCell = calendarContainer.buttons.matching(predicate).firstMatch
        
        XCTAssertTrue(futureCell.waitForExistence(timeout: 3))
        futureCell.tap()
        
        let resetButton = app.buttons["resetToTodayButton"]
        XCTAssertTrue(resetButton.waitForExistence(timeout: 2))
    }
    
    func testResetButton_tap_resetsDateToToday() {
        let calendarContainer = app.otherElements["gatherlyCalendar"]
        XCTAssertTrue(calendarContainer.waitForExistence(timeout: 2))
        
        let now = Date()
        let calendar = Calendar.current
        guard let future = calendar.date(byAdding: .day, value: 2, to: now) else {
            XCTFail("Unable to compute future date.")
            return
        }
        
        if !calendar.isDate(future, equalTo: now, toGranularity: .month) {
            let nextMonthButton = calendarContainer.buttons["Next Month"]
            XCTAssertTrue(nextMonthButton.waitForExistence(timeout: 2))
            nextMonthButton.tap()
            sleep(1)
        }
        
        let monthDayFormatter = DateFormatter()
        monthDayFormatter.dateFormat = "MMMM d"
        let monthDayString = monthDayFormatter.string(from: future)
        
        let predicate = NSPredicate(format: "label CONTAINS[c] %@", monthDayString)
        let futureCell = calendarContainer.buttons.matching(predicate).firstMatch
        XCTAssertTrue(futureCell.waitForExistence(timeout: 3))
        futureCell.tap()
        
        let resetButton = app.buttons["resetToTodayButton"]
        XCTAssertTrue(resetButton.waitForExistence(timeout: 2))
        
        resetButton.tap()
        
        let header = app.staticTexts["calendarMonthHeader"]
        XCTAssertTrue(header.waitForExistence(timeout: 2))
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM d"
        let expectedHeader = dateFormatter.string(from: now)
        
        XCTAssertEqual(header.label, expectedHeader)
        XCTAssertFalse(app.buttons["resetToTodayButton"].exists)
    }
}
