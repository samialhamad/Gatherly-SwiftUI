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
    
    func makeEvent(id: Int, date: Date) -> Event {
        Event(date: date, id: id)
    }
    
    // MARK: - eventCountLabel
    
    func testEventCountLabel_pastDateNoEvents() {
        let yesterday = Date().minus(calendarComponent: .day, value: 1)!
        let label = [Event]().eventCountLabel(for: yesterday)
        
        XCTAssertEqual(label, "Looks like nothing happened this day!")
    }
    
    func testEventCountLabel_pastDateOneEvent() {
        let yesterday = Date().minus(calendarComponent: .day, value: 1)!
        let label = [makeEvent(id: 1, date: yesterday)].eventCountLabel(for: yesterday)
        
        XCTAssertEqual(label, "1 finished event!")
    }
    
    func testEventCountLabel_pastDateTwoEvents() {
        let yesterday = Date().minus(calendarComponent: .day, value: 1)!
        let label = [
            makeEvent(id: 1, date: yesterday),
            makeEvent(id: 2, date: yesterday)
        ].eventCountLabel(for: yesterday)
        
        XCTAssertEqual(label, "2 finished events!")
    }
    
    func testEventCountLabel_todayNoEvent() {
        let today = Date()
        let label = [Event]().eventCountLabel(for: today)
        
        XCTAssertEqual(label, "Nothing planned for today!")
    }
    
    func testEventCountLabel_todaySingleEvent() {
        let today = Calendar.current.startOfDay(for: Date())
        let label = [makeEvent(id: 1, date: today)].eventCountLabel(for: today)
        
        XCTAssertEqual(label, "1 event planned for today!")
    }
    
    func testEventCountLabel_todayMultipleEvents() {
        let today = Calendar.current.startOfDay(for: Date())
        let label = [
            makeEvent(id: 1, date: today),
            makeEvent(id: 2, date: today)
        ].eventCountLabel(for: today)
        
        XCTAssertEqual(label, "2 events planned for today!")
    }
    
    func testEventCountLabel_futureNoEvents() {
        let tomorrow = Date().plus(calendarComponent: .day, value: 1)!
        let label = [Event]().eventCountLabel(for: tomorrow)
        
        XCTAssertEqual(label, "No upcoming plans!")
    }
    
    func testEventCountLabel_futureOneEvent() {
        let tomorrow = Date().plus(calendarComponent: .day, value: 1)!
        let label = [makeEvent(id: 1, date: tomorrow)].eventCountLabel(for: tomorrow)
        
        XCTAssertEqual(label, "1 upcoming event!")
    }
    
    func testEventCountLabel_futureMultipleEvents() {
        let tomorrow = Date().plus(calendarComponent: .day, value: 1)!
        let label = [
            makeEvent(id: 1, date: tomorrow),
            makeEvent(id: 2, date: tomorrow)
        ].eventCountLabel(for: tomorrow)
        
        XCTAssertEqual(label, "2 upcoming events!")
    }
    
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
        
        XCTAssertEqual(groupedEvents.count, 2)
        XCTAssertEqual(groupedEvents[key1]?.count, 2)
        XCTAssertEqual(groupedEvents[key2]?.count, 1)
    }
    
    // MARK: - filterEvents
    
    func testFilterEvents_AllEventsSameDay() {
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
            title: "Event 1"
        )
        let event2 = Event(
            date: date2,
            id: 2,
            title: "Event 2"
        )
        
        let events = [event1, event2]
        let filterDay = calendar.startOfDay(for: date1)
        let filteredEvents = events.filterEvents(by: filterDay)
        
        XCTAssertEqual(filteredEvents.count, 2)
    }
    
    func testFilterEvents_MixedDays() {
        // events on two different days.
        let components1 = DateComponents(year: 2025, month: 3, day: 11, hour: 10)
        let components2 = DateComponents(year: 2025, month: 3, day: 12, hour: 12)
        guard let date1 = calendar.date(from: components1),
              let date2 = calendar.date(from: components2) else {
            XCTFail("Failed to create dates")
            return
        }
        
        let event1 = Event(
            date: date1,
            id: 1,
            title: "Event 1"
        )
        let event2 = Event(
            date: date2,
            id: 2,
            title: "Event 2"
        )
        
        let events = [event1, event2]
        let filterDay = calendar.startOfDay(for: date1)
        let filteredEvents = events.filterEvents(by: filterDay)
        
        XCTAssertEqual(filteredEvents.count, 1)
        XCTAssertEqual(filteredEvents.first?.id, event1.id)
    }
}
