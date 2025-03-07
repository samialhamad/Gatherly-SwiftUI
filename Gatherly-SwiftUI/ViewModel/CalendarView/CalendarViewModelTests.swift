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
    
    func testEventCountLabelPastDateNoEvents() {
        let yesterday = Date().minus(calendarComponent: .day, value: 1)!
        let label = viewModel.eventCountLabel(for: yesterday, events: [])
        XCTAssertEqual(label, "No finished events")
    }
    
    func testEventCountLabelPastDateOneEvent() {
        let yesterday = Date().minus(calendarComponent: .day, value: 1)!
        let event = Event(
            date: yesterday,
            description: "Test event 1",
            endTimestamp: nil,
            id: 1,
            plannerID: 1,
            memberIDs: [],
            title: "Test 1",
            startTimestamp: nil
        )
        
        let label = viewModel.eventCountLabel(for: yesterday, events: [event])
        XCTAssertEqual(label, "1 finished event")
    }
    
    func testEventCountLabelPastDateTwoEvents() {
        let yesterday = Date().minus(calendarComponent: .day, value: 1)!
        let event1 = Event(
            date: yesterday,
            description: "Test event 1",
            endTimestamp: nil,
            id: 1,
            plannerID: 1,
            memberIDs: [],
            title: "Test 1",
            startTimestamp: nil
        )
        let event2 = Event(
            date: yesterday,
            description: "Test event 2",
            endTimestamp: nil,
            id: 1,
            plannerID: 1,
            memberIDs: [],
            title: "Test 2",
            startTimestamp: nil
        )
        
        let label = viewModel.eventCountLabel(for: yesterday, events: [event1, event2])
        XCTAssertEqual(label, "2 finished events")
    }
    
    func testEventCountLabelTodayNoEvent() {
        let today = Date()
        
        let label = viewModel.eventCountLabel(for: today, events: [])
        XCTAssertEqual(label, "Nothing planned for today!")
    }
    
    func testEventCountLabelTodaySingleEvent() {
        let today = Date()
        let todayStart = Calendar.current.startOfDay(for: today)
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
    
    func testEventCountLabelTodayMultipleEvents() {
        let today = Date()
        let todayStart = Calendar.current.startOfDay(for: today)
        let event1 = Event(
            date: todayStart,
            description: "Test event",
            endTimestamp: nil,
            id: 1,
            plannerID: 1,
            memberIDs: [],
            title: "Test",
            startTimestamp: nil
        )
        let event2 = Event(
            date: todayStart,
            description: "Test event 2",
            endTimestamp: nil,
            id: 1,
            plannerID: 1,
            memberIDs: [],
            title: "Test 2",
            startTimestamp: nil
        )
        
        let label = viewModel.eventCountLabel(for: today, events: [event1, event2])
        XCTAssertEqual(label, "2 events planned for today")
    }
    
    func testEventCountLabelFutureNoEvents() {
        let tomorrow = Date().plus(calendarComponent: .day, value: 1)!
        
        let label = viewModel.eventCountLabel(for: tomorrow, events: [])
        XCTAssertEqual(label, "No upcoming events")
    }
    
    func testEventCountLabelFutureOneEvent() {
        let tomorrow = Date().plus(calendarComponent: .day, value: 1)!
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
        
        let label = viewModel.eventCountLabel(for: tomorrow, events: [event1])
        XCTAssertEqual(label, "1 upcoming event")
    }
    
    func testEventCountLabelFutureMultipleEvents() {
        let tomorrow = Date().plus(calendarComponent: .day, value: 1)!
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
