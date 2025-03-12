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
    
    func testGroupedByDay_SingleDay() {
        // two events on the same day ( different times).
        let components1 = DateComponents(year: 2025, month: 3, day: 11, hour: 10, minute: 0)
        guard let date1 = calendar.date(from: components1) else {
            XCTFail("Failed to create date1")
            return
        }
        let event1 = Event(
            date: date1,
            id: 1,
            title: "Event1"
        )
        
        let components2 = DateComponents(year: 2025, month: 3, day: 11, hour: 15, minute: 30)
        guard let date2 = calendar.date(from: components2) else {
            XCTFail("Failed to create date2")
            return
        }
        let event2 = Event(
            date: date2,
            id: 2,
            title: "Event2"
        )
        
        let events = [event1, event2]
        let grouped = events.groupedByDay
        
        // expecting a single key, start of day for march 11 2025.
        let expectedKey = calendar.startOfDay(for: date1)
        XCTAssertEqual(grouped.count, 1)
        XCTAssertNotNil(grouped[expectedKey])
        XCTAssertEqual(grouped[expectedKey]?.count, 2)
    }
    
    func testGroupedByDay_MultipleDays() {
        let components1 = DateComponents(year: 2025, month: 3, day: 11, hour: 10)
        guard let date1 = calendar.date(from: components1) else {
            XCTFail("Failed to create date1")
            return
        }
        let event1 = Event(
            date: date1,
            id: 1,
            title: "Event1")
        
        let components2 = DateComponents(year: 2025, month: 3, day: 11, hour: 15)
        guard let date2 = calendar.date(from: components2) else {
            XCTFail("Failed to create date2")
            return
        }
        let event2 = Event(
            date: date2,
            id: 2,
            title: "Event2"
        )
        
        let components3 = DateComponents(year: 2025, month: 3, day: 12, hour: 9)
        guard let date3 = calendar.date(from: components3) else {
            XCTFail("Failed to create date3")
            return
        }
        let event3 = Event(
            date: date3,
            id: 3,
            title: "Event3"
        )
        
        let events = [event1, event2, event3]
        let grouped = events.groupedByDay
        
        let key1 = calendar.startOfDay(for: date1)
        let key2 = calendar.startOfDay(for: date3)
        
        XCTAssertEqual(grouped.count, 2)
        XCTAssertEqual(grouped[key1]?.count, 2)
        XCTAssertEqual(grouped[key2]?.count, 1)
    }
}
