//
//  CalendarViewModelTests.swift
//  Gatherly-SwiftUITests
//
//  Created by Sami Alhamad on 3/5/25.
//

import XCTest
@testable import Gatherly_SwiftUI

final class CalendarViewModelTests: XCTestCase {
    let viewModel = CalendarViewModel()
    let calendar = Calendar.current
    
    func testEventCountLabelPastDateNoEvents() {
        let yesterday = calendar.date(byAdding: .day, value: -1, to: Date())!
        let label = viewModel.eventCountLabel(for: yesterday, events: [])
        XCTAssertEqual(label, "No finished events")
    }
    
    func testEventCountLabelTodaySingleEvent() {
        let today = Date()
        let todayStart = calendar.startOfDay(for: today)
        let event = Event(
            date: todayStart,
            description: "Test event",
            endTimestamp: nil,
            id: 1,
            plannerID: 1,
            memberIDs: [],
            title: "Test",
            startTimestamp: nil
        )
        let label = viewModel.eventCountLabel(for: today, events: [event])
        XCTAssertEqual(label, "1 event planned for today")
    }
    
    func testEventCountLabelFutureMultipleEvents() {
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: Date())!
        let event1 = Event(
            date: tomorrow,
            description: "Test event 1",
            endTimestamp: nil,
            id: 1,
            plannerID: 1,
            memberIDs: [],
            title: "Test 1",
            startTimestamp: nil
        )
        let event2 = Event(
            date: tomorrow,
            description: "Test event 2",
            endTimestamp: nil,
            id: 2,
            plannerID: 1,
            memberIDs: [],
            title: "Test 2",
            startTimestamp: nil
        )
        let label = viewModel.eventCountLabel(for: tomorrow, events: [event1, event2])
        XCTAssertEqual(label, "2 upcoming events")
    }
}
