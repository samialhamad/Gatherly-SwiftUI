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
        
    func makeEvent(id: Int, date: Date) -> Event {
        Event(
            date: date,
            id: id
        )
    }
    
    func testEventCountLabel_pastDateNoEvents() {
        let yesterday = Date().minus(calendarComponent: .day, value: 1)!
        let label = viewModel.eventCountLabel(for: yesterday, events: [])
        
        XCTAssertEqual(label, "No finished events")
    }
    
    func testEventCountLabel_pastDateOneEvent() {
        let yesterday = Date().minus(calendarComponent: .day, value: 1)!
        let event = makeEvent(id: 1, date: yesterday)

        let label = viewModel.eventCountLabel(for: yesterday, events: [event])
        XCTAssertEqual(label, "1 finished event")
    }
    
    func testEventCountLabel_pastDateTwoEvents() {
        let yesterday = Date().minus(calendarComponent: .day, value: 1)!
        let event1 = makeEvent(id: 1, date: yesterday)
        let event2 = makeEvent(id: 2, date: yesterday)
        
        let label = viewModel.eventCountLabel(for: yesterday, events: [event1, event2])
        XCTAssertEqual(label, "2 finished events")
    }
    
    func testEventCountLabel_todayNoEvent() {
        let today = Date()
        
        let label = viewModel.eventCountLabel(for: today, events: [])
        XCTAssertEqual(label, "Nothing planned for today!")
    }
    
    func testEventCountLabel_todaySingleEvent() {
        let today = Date()
        let todayStart = Calendar.current.startOfDay(for: today)
        let event = makeEvent(id: 1, date: todayStart)

        let label = viewModel.eventCountLabel(for: today, events: [event])
        XCTAssertEqual(label, "1 event planned for today")
    }
    
    func testEventCountLabel_todayMultipleEvents() {
        let today = Date()
        let todayStart = Calendar.current.startOfDay(for: today)
        let event1 = makeEvent(id: 1, date: todayStart)
        let event2 = makeEvent(id: 2, date: todayStart)

        let label = viewModel.eventCountLabel(for: today, events: [event1, event2])
        XCTAssertEqual(label, "2 events planned for today")
    }
    
    func testEventCountLabel_futureNoEvents() {
        let tomorrow = Date().plus(calendarComponent: .day, value: 1)!
        
        let label = viewModel.eventCountLabel(for: tomorrow, events: [])
        XCTAssertEqual(label, "No upcoming events")
    }
    
    func testEventCountLabel_futureOneEvent() {
        let tomorrow = Date().plus(calendarComponent: .day, value: 1)!
        let event = makeEvent(id: 1, date: tomorrow)
        
        let label = viewModel.eventCountLabel(for: tomorrow, events: [event])
        XCTAssertEqual(label, "1 upcoming event")
    }
    
    func testEventCountLabel_futureMultipleEvents() {
        let tomorrow = Date().plus(calendarComponent: .day, value: 1)!
        let event1 = makeEvent(id: 1, date: tomorrow)
        let event2 = makeEvent(id: 2, date: tomorrow)
       
        let label = viewModel.eventCountLabel(for: tomorrow, events: [event1, event2])
        XCTAssertEqual(label, "2 upcoming events")
    }
}
