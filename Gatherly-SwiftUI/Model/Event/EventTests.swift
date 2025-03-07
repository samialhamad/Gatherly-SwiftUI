//
//  EventTests.swift
//  Gatherly-SwiftUITests
//
//  Created by Sami Alhamad on 3/4/25.
//

import XCTest
@testable import Gatherly_SwiftUI

final class EventTests: XCTestCase {
    
    func testEventHasStartedTrue() {
        let pastDate = Date().minus(calendarComponent: .hour, value: 1)!
        let pastTimestamp = pastDate.timestamp
        let event = Event(startTimestamp: pastTimestamp)
        
        XCTAssertTrue(event.hasStarted)
    }
    
    func testEventHasStartedFalse() {
        let futureDate = Date().plus(calendarComponent: .hour, value: 1)!
        let futureTimestamp = futureDate.timestamp
        let event = Event(startTimestamp: futureTimestamp)
        
        XCTAssertFalse(event.hasStarted)
    }
    
    func testEventHasEndedTrue() {
        let pastDate = Date().minus(calendarComponent: .hour, value: 1)!
        let pastTimestamp = pastDate.timestamp
        let event = Event(endTimestamp: pastTimestamp)
        
        XCTAssertTrue(event.hasEnded)
    }
    
    func testEventHasEndedFalse() {
        let futureDate = Date().plus(calendarComponent: .hour, value: 1)!
        let futureTimestamp = futureDate.timestamp
        let event = Event(endTimestamp: futureTimestamp)
        
        XCTAssertFalse(event.hasEnded)
    }
    
    func testEventIsOngoingTrue() {
        let currentTimestamp = Date().timestamp
        let startDate = Date().minus(calendarComponent: .hour, value: 1)!
        let endDate = Date().plus(calendarComponent: .hour, value: 1)!
        let event = Event(endTimestamp: endDate.timestamp, startTimestamp: startDate.timestamp)
        
        XCTAssertTrue(event.isOngoing)
    }
    
    func testEventIsOngoingFalse() {
        let startDate = Date().minus(calendarComponent: .hour, value: 3)!
        let endDate = Date().minus(calendarComponent: .hour, value: 1)!
        let event = Event(endTimestamp: endDate.timestamp, startTimestamp: startDate.timestamp)
        
        XCTAssertFalse(event.isOngoing)
    }
    
    func testEventIsOngoingFalse_EventHasNotStarted() {
        let startDate = Date().plus(calendarComponent: .hour, value: 1)!
        let endDate = Date().plus(calendarComponent: .hour, value: 3)!
        let event = Event(endTimestamp: endDate.timestamp, startTimestamp: startDate.timestamp)
        
        XCTAssertFalse(event.isOngoing)
    }
}
