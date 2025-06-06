//
//  EditEventViewUITests.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 5/20/25.
//

import XCTest

final class EditEventFormViewUITests: GatherlyUITestCase {
    
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
    
    func testEditEventFormViewLoads() {
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
    
    func testEditingTitleUpdatesNavigationBar() {
        let titleField = app.textFields["eventTitleTextField"]
        XCTAssertTrue(titleField.waitForExistence(timeout: 2))
        XCTAssertTrue(titleField.isHittable)
        
        titleField.tap()
        titleField.clearAndEnterText("My Updated Event Title")
        
        let saveButton = app.buttons["saveEventButton"]
        XCTAssertTrue(saveButton.waitForExistence(timeout: 2))
        XCTAssertTrue(saveButton.isEnabled)
        saveButton.tap()
        
        let updatedNavBar = app.navigationBars["My Updated Event Title"]
        XCTAssertTrue(updatedNavBar.waitForExistence(timeout: 5))
    }
    
    func testEditingDateUpdatesDayEventsAndCalendar() {
        let now = Date()
        let calendar = Calendar.current
        guard let tomorrow = calendar.date(byAdding: .day, value: 1, to: now) else {
            XCTFail("Could not compute tomorrow’s date.")
            return
        }
        
        let longDateFormatter = DateFormatter()
        longDateFormatter.dateStyle = .long
        longDateFormatter.timeStyle = .none
        
        let expectedDayEventsNavTitle = longDateFormatter.string(from: tomorrow)
        let expectedCalendarHeader = tomorrow.formatted(.dateTime.weekday(.wide).month(.wide).day())
        
        let datePicker = app.datePickers["eventDatePicker"]
        XCTAssertTrue(datePicker.waitForExistence(timeout: 2))
        datePicker.tap()
        sleep(1)
        
        if !calendar.isDate(tomorrow, equalTo: now, toGranularity: .month) {
            var nextMonthButton: XCUIElement? = datePicker.buttons[">"]
            
            if !(nextMonthButton?.exists ?? false) {
                let fallback = app.buttons["Next Month"]
                if fallback.exists {
                    nextMonthButton = fallback
                }
            }
            
            if nextMonthButton == nil || !(nextMonthButton!.exists) {
                let fallback2 = app.buttons[">"]
                if fallback2.exists {
                    nextMonthButton = fallback2
                }
            }
            
            XCTAssertNotNil(nextMonthButton)
            XCTAssertTrue(nextMonthButton!.isHittable)
            nextMonthButton!.tap()
            sleep(1)
        }
        
        let monthDayFormatter = DateFormatter()
        monthDayFormatter.dateFormat = "MMMM d"
        let monthDayString = monthDayFormatter.string(from: tomorrow)
        
        let predicate = NSPredicate(format: "label CONTAINS[c] %@", monthDayString)
        let potentialCells = app.buttons.matching(predicate)
        let tomorrowCell = potentialCells.firstMatch
        
        XCTAssertTrue(tomorrowCell.waitForExistence(timeout: 3))
        tomorrowCell.tap()
        
        app.tap() // dismiss DatePicker
        sleep(1)
        
        let saveButton = app.buttons["saveEventButton"]
        XCTAssertTrue(saveButton.waitForExistence(timeout: 2))
        XCTAssertTrue(saveButton.isEnabled)
        saveButton.tap()
        
        let detailNavBar = app.navigationBars["Event 3 Today"]
        XCTAssertTrue(detailNavBar.waitForExistence(timeout: 5))
        let detailBackButton = detailNavBar.buttons.element(boundBy: 0)
        XCTAssertTrue(detailBackButton.exists)
        detailBackButton.tap()
        
        let dayEventsNavBar = app.navigationBars[expectedDayEventsNavTitle]
        XCTAssertTrue(dayEventsNavBar.waitForExistence(timeout: 5))
        
        let backButton = dayEventsNavBar.buttons.element(boundBy: 0)
        XCTAssertTrue(backButton.exists)
        backButton.tap()
        
        let calendarHeader = app.staticTexts["calendarMonthHeader"]
        XCTAssertTrue(calendarHeader.waitForExistence(timeout: 3))
        XCTAssertEqual(calendarHeader.label, expectedCalendarHeader)
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
    
    func testDeleteButton_removesEvent_fromDayEventsView() {
        let deleteButton = app.buttons["deleteEventButton"]
        app.swipeUp()
        XCTAssertTrue(deleteButton.waitForExistence(timeout: 2))
        deleteButton.tap()
        
        let alert = app.alerts["Delete Event?"]
        alert.buttons["Delete"].tap()
        
        sleep(2)
        
        let deletedEventRow = app.buttons["eventRow-Event 3 Today"]
        XCTAssertFalse(deletedEventRow.exists)
    }
}
