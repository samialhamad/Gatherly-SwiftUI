//
//  ArrayTests.swift
//  Gatherly-SwiftUITests
//
//  Created by Sami Alhamad on 3/12/25.
//

import XCTest
@testable import Gatherly_SwiftUI

final class ArrayTests: XCTestCase {
    
    let calendar = Calendar.current
    
    //MARK: - groupEventsByDay
    
    func testGroupEventsByDay_SingleDay() {
        // two events on the same day ( different times).
        let components1 = DateComponents(year: 2025, month: 3, day: 11, hour: 10, minute: 0)
        let components2 = DateComponents(year: 2025, month: 3, day: 11, hour: 15, minute: 30)
        
        guard let date1 = calendar.date(from: components1),
              let date2 = calendar.date(from: components2) else {
            XCTFail("Failed to create dates")
            return
        }
        
        let event1 = Event(
            date: date1,
            id: 1,
            title: "Event1"
        )
        let event2 = Event(
            date: date2,
            id: 2,
            title: "Event2"
        )
        
        let events = [event1, event2]
        let groupedEvents = events.groupEventsByDay
        
        // expecting a single key, start of day for march 11 2025.
        let expectedKey = calendar.startOfDay(for: date1)
        XCTAssertEqual(groupedEvents.count, 1)
        XCTAssertNotNil(groupedEvents[expectedKey])
        XCTAssertEqual(groupedEvents[expectedKey]?.count, 2)
    }
    
    func testGroupEventsByDay_MultipleDays() {
        let components1 = DateComponents(year: 2025, month: 3, day: 11, hour: 10)
        let components2 = DateComponents(year: 2025, month: 3, day: 11, hour: 15)
        let components3 = DateComponents(year: 2025, month: 3, day: 12, hour: 9)
        
        guard let date1 = calendar.date(from: components1),
              let date2 = calendar.date(from: components2),
              let date3 = calendar.date(from: components3)
        else {
            XCTFail("Failed to create dates")
            return
        }
        
        let event1 = Event(
            date: date1,
            id: 1,
            title: "Event1")
        let event2 = Event(
            date: date2,
            id: 2,
            title: "Event2"
        )
        let event3 = Event(
            date: date3,
            id: 3,
            title: "Event3"
        )
        
        let events = [event1, event2, event3]
        let groupedEvents = events.groupEventsByDay
        
        let key1 = calendar.startOfDay(for: date1)
        let key2 = calendar.startOfDay(for: date3)
        
        XCTAssertEqual(grouped.count, 2)
        XCTAssertEqual(grouped[key1]?.count, 2)
        XCTAssertEqual(grouped[key2]?.count, 1)
        XCTAssertEqual(groupedEvents.count, 2)
        XCTAssertEqual(groupedEvents[key1]?.count, 2)
        XCTAssertEqual(groupedEvents[key2]?.count, 1)
    }
}
