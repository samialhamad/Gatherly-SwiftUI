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
    
    let finishedEvent: Event = SampleData.sampleEvents[1]
    let onGoingEvent: Event = SampleData.sampleEvents[2]
    let upcomingEvent: Event = SampleData.sampleEvents[3]
    
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
