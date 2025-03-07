//
//  EventTests.swift
//  Gatherly-SwiftUITests
//
//  Created by Sami Alhamad on 3/4/25.
//

import XCTest
@testable import Gatherly_SwiftUI

final class EventTests: XCTestCase {
    
    //MARK: - Computed Vars
    
    func testEventHasStartedTrue() {
        let pastTimestamp = Int(Date().timestamp) - 3600 // 1 hour ago
        let event = Event(startTimestamp: pastTimestamp)
        
        XCTAssertTrue(event.hasStarted)
    }
    
    func testEventHasStartedFalse() {
        let futureTimestamp = Int(Date().timestamp) + 3600 // 1 hour ahead
        let event = Event(startTimestamp: futureTimestamp)
        
        XCTAssertFalse(event.hasStarted)
    }
    
    func testEventHasEndedTrue() {
        let pastTimestamp = Int(Date().timestamp) - 3600 // 1 hour ago
        let event = Event(endTimestamp: pastTimestamp)
        
        XCTAssertTrue(event.hasEnded)
    }
    
    func testEventHasEndedFalse() {
        let futureTimestamp = Int(Date().timestamp) + 3600 // 1 hour ahead
        let event = Event(endTimestamp: futureTimestamp)
        
        XCTAssertFalse(event.hasEnded)
    }
    
    func testEventIsOngoingTrue() {
        let currentTimestamp = Int(Date().timestamp)
        let startTimestamp = currentTimestamp - 3600 // Started 1 hour ago
        let endTimestamp = currentTimestamp + 3600   // Ends 1 hour from now
        
        let event = Event(endTimestamp: endTimestamp, startTimestamp: startTimestamp)
        
        XCTAssertTrue(event.isOngoing)
    }
    
    func testEventIsOngoingFalse() {
        let currentTimestamp = Int(Date().timestamp)
        let startTimestamp = currentTimestamp - 7200 // Started 2 hours ago
        let endTimestamp = currentTimestamp - 3600   // Ended 1 hour ago
        
        let event = Event(endTimestamp: endTimestamp, startTimestamp: startTimestamp)
        
        XCTAssertFalse(event.isOngoing)
    }
    
    func testEventIsOngoingFalse_EventHasNotStarted() {
        let currentTimestamp = Int(Date().timestamp)
        let startTimestamp = currentTimestamp + 3600 // Starts in 1 hour
        let endTimestamp = currentTimestamp + 7200   // Ends in 2 hours
        
        let event = Event(endTimestamp: endTimestamp, startTimestamp: startTimestamp)
        
        XCTAssertFalse(event.isOngoing)
    }
}
