//
//  SwiftUICalendarViewTests.swift
//  Gatherly-SwiftUITests
//
//  Created by Sami Alhamad on 6/5/25.
//

import XCTest
@testable import Gatherly_SwiftUI

final class SwiftUICalendarViewTests: XCTestCase {
    
    // MARK: - Helper
    
    private func dateAt(year: Int, month: Int, day: Int) -> Date {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        
        return Calendar.current.date(from: components)!
    }
    
    func testHasEvent_returnsTrue() {
        let eventDate = dateAt(year: 2025, month: 1, day: 11)
        let timestamp = Int(Date.startOfDay(eventDate).timestamp)
        
        let event = Event(
            id: 123,
            plannerID: 1,
            startTimestamp: timestamp
        )
        
        let hasEvent = SwiftUICalendarView.hasEvent(in: [event], on: eventDate)
        
        XCTAssertTrue(hasEvent)
    }
    
    func testHasEvent_returnsFalse() {
        let eventDate = dateAt(year: 2025, month: 1, day: 1)
        let timestamp = Int(Date.startOfDay(eventDate).timestamp)
        
        let event = Event(
            id: 456,
            plannerID: 1,
            startTimestamp: timestamp
        )
        
        let selectedDate = dateAt(year: 2025, month: 1, day: 3)
        
        let hasEvent = SwiftUICalendarView.hasEvent(in: [event], on: selectedDate)
        
        XCTAssertFalse(hasEvent)
    }
}
