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
}
