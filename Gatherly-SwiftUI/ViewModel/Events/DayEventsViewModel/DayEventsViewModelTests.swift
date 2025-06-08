//
//  DayEventsViewModelTests.swift
//  Gatherly-SwiftUITests
//
//  Created by Sami Alhamad on 6/7/25.
//

import XCTest
@testable import Gatherly_SwiftUI

final class DayEventsViewModelTests: XCTestCase {
    
    let today = Date()
    
    let finishedEvent: Event = Event(
        categories: [],
        description: "",
        endTimestamp: Int((Date().minus(calendarComponent: .hour, value: 1) ?? Date()).timestamp),
        id: 1,
        plannerID: 1,
        location: nil,
        memberIDs: [2, 3],
        title: "Finished Event",
        startTimestamp: Int((Date().minus(calendarComponent: .hour, value: 2) ?? Date()).timestamp)
    )
    
    let onGoingEvent: Event = Event(
        categories: [],
        description: "",
        endTimestamp: Int((Date().plus(calendarComponent: .hour, value: 1) ?? Date()).timestamp),
        id: 3,
        plannerID: 1,
        location: nil,
        memberIDs: [2, 3],
        title: "On Going Event",
        startTimestamp: Int((Date().minus(calendarComponent: .hour, value: 1) ?? Date()).timestamp)
    )
    
    let upcomingEvent: Event = Event(
        categories: [],
        description: "",
        endTimestamp: Int((Date().plus(calendarComponent: .hour, value: 2) ?? Date()).timestamp),
        id: 4,
        plannerID: 1,
        location: nil,
        memberIDs: [2, 3],
        title: "Upcoming Event",
        startTimestamp: Int((Date().plus(calendarComponent: .hour, value: 1) ?? Date()).timestamp)
    )
    
    func testFinishedEvents() {
        let finishedEvents = DayEventsViewModel.finishedEvents(
            for: [finishedEvent, onGoingEvent, upcomingEvent],
            on: today
        )
        
        XCTAssertTrue(finishedEvents.contains(finishedEvent))
        XCTAssertFalse(finishedEvents.contains(onGoingEvent))
        XCTAssertFalse(finishedEvents.contains(upcomingEvent))
    }
    
    func testOnGoingEvents() {
        let onGoingEvents = DayEventsViewModel.onGoingEvents(
            for: [finishedEvent, onGoingEvent, upcomingEvent],
            on: today
        )
        
        XCTAssertTrue(onGoingEvents.contains(onGoingEvent))
        XCTAssertFalse(onGoingEvents.contains(finishedEvent))
        XCTAssertFalse(onGoingEvents.contains(upcomingEvent))
    }
    
    func testUpcomingEvents() {
        let upcomingEvents = DayEventsViewModel.upcomingEvents(
            for: [finishedEvent, onGoingEvent, upcomingEvent],
            on: today
        )
        
        XCTAssertTrue(upcomingEvents.contains(upcomingEvent))
        XCTAssertFalse(upcomingEvents.contains(finishedEvent))
        XCTAssertFalse(upcomingEvents.contains(onGoingEvent))
    }
}
