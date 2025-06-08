//
//  GatherlyCalendarViewModelTests.swift
//  Gatherly-SwiftUITests
//
//  Created by Sami Alhamad on 6/4/25.
//

import XCTest
@testable import Gatherly_SwiftUI

final class GatherlyCalendarViewModelTests: XCTestCase {
    
    let calendar = Calendar.current
    let gatherlyCalendarViewModel = GatherlyCalendarViewModel()
    
    func makeEvent(id: Int, date: Date) -> Event {
        Event(
            id: id,
            startTimestamp: Int(date.timestamp)
        )
    }
    
    // MARK: - eventCountLabel
    
    func testEventCountLabel_pastDateNoEvents() {
        let yesterday = Date().minus(calendarComponent: .day, value: 1)!
        let events: [Event] = []
        let label = gatherlyCalendarViewModel.eventCountLabel(for: yesterday, events: events)

        XCTAssertEqual(label, "Looks like nothing happened this day!")
    }
    
    func testEventCountLabel_pastDateOneEvent() {
        let yesterday = Date().minus(calendarComponent: .day, value: 1)!
        let events = [makeEvent(id: 1, date: yesterday)]
        let label = gatherlyCalendarViewModel.eventCountLabel(for: yesterday, events: events)

        XCTAssertEqual(label, "1 finished event!")
    }
    
    func testEventCountLabel_pastDateTwoEvents() {
        let yesterday = Date().minus(calendarComponent: .day, value: 1)!
        let events = [
            makeEvent(id: 1, date: yesterday),
            makeEvent(id: 2, date: yesterday)
        ]
        let label = gatherlyCalendarViewModel.eventCountLabel(for: yesterday, events: events)
        
        XCTAssertEqual(label, "2 finished events!")
    }
    
    func testEventCountLabel_todayNoEvent() {
        let today = Date()
        let events: [Event] = []
        let label = gatherlyCalendarViewModel.eventCountLabel(for: today, events: events)
        
        XCTAssertEqual(label, "Nothing planned for today!")
    }
    
    func testEventCountLabel_todaySingleEvent() {
        let today = Calendar.current.startOfDay(for: Date())
        let events = [makeEvent(id: 1, date: today)]
        let label = gatherlyCalendarViewModel.eventCountLabel(for: today, events: events)
        
        XCTAssertEqual(label, "1 event planned for today!")
    }
    
    func testEventCountLabel_todayMultipleEvents() {
        let today = Calendar.current.startOfDay(for: Date())
        let events = [
            makeEvent(id: 1, date: today),
            makeEvent(id: 2, date: today)
        ]
        let label = gatherlyCalendarViewModel.eventCountLabel(for: today, events: events)
        
        XCTAssertEqual(label, "2 events planned for today!")
    }
    
    func testEventCountLabel_futureNoEvents() {
        let tomorrow = Date().plus(calendarComponent: .day, value: 1)!
        let events: [Event] = []
        let label = gatherlyCalendarViewModel.eventCountLabel(for: tomorrow, events: events)
        
        XCTAssertEqual(label, "No plans on \(tomorrow.formatted(.dateTime.weekday(.wide).month(.wide).day()))!")
    }
    
    func testEventCountLabel_futureOneEvent() {
        let tomorrow = Date().plus(calendarComponent: .day, value: 1)!
        let events = [makeEvent(id: 1, date: tomorrow)]
        let label = gatherlyCalendarViewModel.eventCountLabel(for: tomorrow, events: events)
                
        XCTAssertEqual(label, "1 upcoming event on \(tomorrow.formatted(.dateTime.weekday(.wide).month(.wide).day()))!")
    }
    
    func testEventCountLabel_futureMultipleEvents() {
        let tomorrow = Date().plus(calendarComponent: .day, value: 1)!
        let events = [
            makeEvent(id: 1, date: tomorrow),
            makeEvent(id: 2, date: tomorrow)
        ]
        let label = gatherlyCalendarViewModel.eventCountLabel(for: tomorrow, events: events)
        
        XCTAssertEqual(label, "2 upcoming events on \(tomorrow.formatted(.dateTime.weekday(.wide).month(.wide).day()))!")
    }
}
