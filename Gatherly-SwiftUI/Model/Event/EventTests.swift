//
//  EventTests.swift
//  Gatherly-SwiftUITests
//
//  Created by Sami Alhamad on 3/4/25.
//

import XCTest
@testable import Gatherly_SwiftUI

final class EventTests: XCTestCase {
    
    // MARK: - Computed Vars
    
    func testDate_ReturnsNilWhenStartTimestampIsNil() {
        let event = Event(startTimestamp: nil)
        XCTAssertNil(event.date)
    }
    
    func testDate_ReturnsStartOfDayForGivenTimestamp() {
        var components = DateComponents()
        components.year = 2025
        components.month = 1
        components.day = 1
        components.hour = 14
        components.minute = 30
        
        let calendar = Calendar.current
        let dateTime = calendar.date(from: components)!
        let timestamp = Int(dateTime.timestamp)
        
        let event = Event(startTimestamp: timestamp)
        
        let expectedStartOfDay = Date.startOfDay(dateTime)
        
        XCTAssertEqual(event.date, expectedStartOfDay)
    }
    
    func testEventHasStartedTrue() {
        let pastDate = Date().minus(calendarComponent: .hour, value: 1)!
        let pastTimestamp = pastDate.timestamp
        let event = Event(startTimestamp: pastTimestamp)
        
        XCTAssertTrue(event.hasStarted)
    }
    
    func testEventHasStartedFalse() {
        let futureDate = Date().plus(calendarComponent: .hour, value: 1)!
        let futureTimestamp = futureDate.timestamp
        let event = Event(startTimestamp: futureTimestamp)
        
        XCTAssertFalse(event.hasStarted)
    }
    
    func testEventHasEndedTrue() {
        let pastDate = Date().minus(calendarComponent: .hour, value: 1)!
        let pastTimestamp = pastDate.timestamp
        let event = Event(endTimestamp: pastTimestamp)
        
        XCTAssertTrue(event.hasEnded)
    }
    
    func testEventHasEndedFalse() {
        let futureDate = Date().plus(calendarComponent: .hour, value: 1)!
        let futureTimestamp = futureDate.timestamp
        let event = Event(endTimestamp: futureTimestamp)
        
        XCTAssertFalse(event.hasEnded)
    }
    
    func testEventIsOngoingTrue() {
        let currentTimestamp = Date().timestamp
        let startDate = Date().minus(calendarComponent: .hour, value: 1)!
        let endDate = Date().plus(calendarComponent: .hour, value: 1)!
        let event = Event(endTimestamp: endDate.timestamp, startTimestamp: startDate.timestamp)
        
        XCTAssertTrue(event.isOngoing)
    }
    
    func testEventIsOngoingFalse() {
        let startDate = Date().minus(calendarComponent: .hour, value: 3)!
        let endDate = Date().minus(calendarComponent: .hour, value: 1)!
        let event = Event(endTimestamp: endDate.timestamp, startTimestamp: startDate.timestamp)
        
        XCTAssertFalse(event.isOngoing)
    }
    
    func testEventIsOngoingFalse_EventHasNotStarted() {
        let startDate = Date().plus(calendarComponent: .hour, value: 1)!
        let endDate = Date().plus(calendarComponent: .hour, value: 3)!
        let event = Event(endTimestamp: endDate.timestamp, startTimestamp: startDate.timestamp)
        
        XCTAssertFalse(event.isOngoing)
    }
    
    // MARK: - SortKey
    
    func testSortKey_EarlierDateComesFirst() {
        // Event A on Jan 1, 2025 at 10:00
        var components = DateComponents()
        components.year = 2025
        components.month = 1
        components.day = 1
        components.hour = 10
        let dateA = Calendar.current.date(from: components)!
        let timestampA = Int(dateA.timestamp)
        let eventA = Event(startTimestamp: timestampA)
        
        // Event B on Jan 2, 2025 at 09:00
        components.day = 2
        components.hour = 9
        let dateB = Calendar.current.date(from: components)!
        let timestampB = Int(dateB.timestamp)
        let eventB = Event(startTimestamp: timestampB)
        
        XCTAssertTrue(eventA.sortKey < eventB.sortKey)
    }
    
    func testSortKey_NilDateIsTreatedAsDistantFuture() {
        // Event A has no date (nil)
        let eventA = Event(startTimestamp: nil)
        
        // Event B is today
        let today = Date()
        let eventB = Event(startTimestamp: Int(today.timestamp))
        
        XCTAssertTrue(eventB.sortKey < eventA.sortKey)
    }
    
    func testSortKey_SameDay_ComparesStartTimestamp() {
        // Both events on Jan 1, 2025, but one at 08:00 and one at 17:00
        var components = DateComponents()
        components.year = 2025
        components.month = 1
        components.day = 1
        
        components.hour = 8
        let dateA = Calendar.current.date(from: components)!
        let eventEarly = Event(startTimestamp: Int(dateA.timestamp))
        
        components.hour = 17
        let dateB = Calendar.current.date(from: components)!
        let eventLate = Event(startTimestamp: Int(dateB.timestamp))
        
        XCTAssertTrue(eventEarly.sortKey < eventLate.sortKey)
    }
    
    func testSortKey_SameDay_NilStartTimestampDefaultsToZero() {
        // Both events on Jan 1, 2025
        var components = DateComponents()
        components.year = 2025
        components.month = 1
        components.day = 1
        
        // Event A has startTimeStamp should to 0
        let dateA = Calendar.current.date(from: components)!
        let eventA = Event(startTimestamp: Int(dateA.timestamp))
        
        // Event B set to a later timestamp
        components.hour = 12
        let dateB = Calendar.current.date(from: components)!
        let eventB = Event(startTimestamp: Int(dateB.timestamp))
        
        XCTAssertTrue(eventA.sortKey < eventB.sortKey)
    }
}
