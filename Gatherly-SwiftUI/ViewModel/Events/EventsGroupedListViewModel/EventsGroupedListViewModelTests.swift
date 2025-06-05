//
//  EventsGroupedListViewModelTests.swift
//  Gatherly-SwiftUITests
//
//  Created by Sami Alhamad on 3/13/25.
//

import XCTest
@testable import Gatherly_SwiftUI

final class EventsGroupedListViewModelTests: XCTestCase {
    
    let calendar = Calendar.current
    
    // MARK: - groupEventsByDay
    
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
            id: 1,
            title: "Event1",
            startTimestamp: Int(date1.timestamp)
        )
        let event2 = Event(
            id: 2,
            title: "Event2",
            startTimestamp: Int(date2.timestamp)
        )
        
        let events = [event1, event2]
        let viewModel = EventsGroupedListViewModel()
        let groupedEvents = viewModel.groupEventsByDay(events: events)
        
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
            id: 1,
            title: "Event1",
            startTimestamp: Int(date1.timestamp)
        )
        let event2 = Event(
            id: 2,
            title: "Event2",
            startTimestamp: Int(date2.timestamp)
        )
        let event3 = Event(
            id: 3,
            title: "Event3",
            startTimestamp: Int(date3.timestamp)
        )
        
        let events = [event1, event2, event3]
        let viewModel = EventsGroupedListViewModel()
        let groupedEvents = viewModel.groupEventsByDay(events: events)
        
        let key1 = calendar.startOfDay(for: date1)
        let key2 = calendar.startOfDay(for: date3)
        
        XCTAssertEqual(groupedEvents.count, 2)
        XCTAssertEqual(groupedEvents[key1]?.count, 2)
        XCTAssertEqual(groupedEvents[key2]?.count, 1)
    }
}
