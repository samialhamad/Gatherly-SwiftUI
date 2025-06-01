//
//  GatherlyCalendarViewUITests.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 5/19/25.
//

import XCTest

final class GatherlyCalendarViewUITests: GatherlyUITestCase {
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
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
    
    func testCalendarHeaderStartsAsToday() {
        let header = app.staticTexts["calendarMonthHeader"]
        XCTAssertTrue(header.waitForExistence(timeout: 2))
        
        let today = Date()
        let expectedHeader = today.formatted(.dateTime.weekday(.wide).month(.wide).day())
        
        XCTAssertEqual(header.label, expectedHeader)
    }
    
    func testSelectingTomorrowUpdatesCalendarHeader_and_NavigatesToDayEventsView() {
        let calendarContainer = app.otherElements["gatherlyCalendar"]
        XCTAssertTrue(calendarContainer.waitForExistence(timeout: 2))
        
        let now = Date()
        let calendar = Calendar.current
        guard let tomorrow = calendar.date(byAdding: .day, value: 1, to: now) else {
            XCTFail("Could not compute tomorrow’s date.")
            return
        }
        
        if !calendar.isDate(tomorrow, equalTo: now, toGranularity: .month) {
            let nextMonthButton = calendarContainer.buttons["Next Month"]
            XCTAssertTrue(nextMonthButton.waitForExistence(timeout: 2))
            nextMonthButton.tap()
            sleep(1)
        }
        
        let monthDayFormatter = DateFormatter()
        monthDayFormatter.dateFormat = "MMMM d"
        let monthDayString = monthDayFormatter.string(from: tomorrow)
        
        let predicate = NSPredicate(format: "label CONTAINS[c] %@", monthDayString)
        let tomorrowCell = calendarContainer.buttons.matching(predicate).firstMatch
        
        XCTAssertTrue(tomorrowCell.waitForExistence(timeout: 3))
        tomorrowCell.tap()
        
        let longDateFormatter = DateFormatter()
        longDateFormatter.dateStyle = .long
        longDateFormatter.timeStyle = .none
        let expectedDayEventsTitle = longDateFormatter.string(from: tomorrow)
        
        let dayEventsNavBar = app.navigationBars[expectedDayEventsTitle]
        XCTAssertTrue(dayEventsNavBar.waitForExistence(timeout: 5))
        
        let backButton = dayEventsNavBar.buttons.element(boundBy: 0)
        XCTAssertTrue(backButton.exists)
        backButton.tap()
        
        let expectedCalendarHeader = tomorrow.formatted(.dateTime.weekday(.wide).month(.wide).day())
        
        let calendarHeader = app.staticTexts["calendarMonthHeader"]
        XCTAssertTrue(calendarHeader.waitForExistence(timeout: 3))
        XCTAssertEqual(calendarHeader.label, expectedCalendarHeader)
    }
    
    func testSelectingTwoDaysForwardShowsNoUpcomingPlans() {
        let calendarContainer = app.otherElements["gatherlyCalendar"]
        XCTAssertTrue(calendarContainer.waitForExistence(timeout: 2))
        
        let now = Date()
        let calendar = Calendar.current
        guard let dayAfterTomorrow = calendar.date(byAdding: .day, value: 2, to: now) else {
            XCTFail("Could not compute the date two days ahead.")
            return
        }
        
        if !calendar.isDate(dayAfterTomorrow, equalTo: now, toGranularity: .month) {
            let nextMonthButton = calendarContainer.buttons["Next Month"]
            XCTAssertTrue(nextMonthButton.waitForExistence(timeout: 2))
            nextMonthButton.tap()
            sleep(1)
        }
        
        let monthDayFormatter = DateFormatter()
        monthDayFormatter.dateFormat = "MMMM d"
        let monthDayString = monthDayFormatter.string(from: dayAfterTomorrow)
        
        let predicate = NSPredicate(format: "label CONTAINS[c] %@", monthDayString)
        let dayCell = calendarContainer.buttons.matching(predicate).firstMatch
        XCTAssertTrue(dayCell.waitForExistence(timeout: 3))
        dayCell.tap()
        
        let noPlansText = app.staticTexts["No upcoming plans!"]
        XCTAssertTrue(noPlansText.waitForExistence(timeout: 2))
    }
}
