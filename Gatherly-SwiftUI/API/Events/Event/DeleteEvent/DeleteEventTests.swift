//
//  DeleteEventTests.swift
//  Gatherly-SwiftUITests
//
//  Created by Sami Alhamad on 5/8/25.
//

import Combine
import XCTest
@testable import Gatherly_SwiftUI

final class DeleteEventTests: XCTestCase {
    
    let calendar = Calendar.current
    var cancellables = Set<AnyCancellable>()
    
    override func setUp() {
        super.setUp()
        UserDefaultsManager.removeEvents()
    }
    
    func testDeleteEvent() {
        let expectation = XCTestExpectation(description: "Event is deleted and only the correct one remains")
        
        let sampleDate = calendar.date(from: DateComponents(year: 2025, month: 3, day: 5))!
        
        var eventToDelete = Event(
            date: calendar.startOfDay(for: sampleDate),
            description: "Event to delete",
            endTimestamp: Int(calendar.date(bySettingHour: 12, minute: 0, second: 0, of: sampleDate)!.timestamp),
            plannerID: 1,
            memberIDs: [2, 3],
            title: "Delete Me",
            startTimestamp: Int(calendar.date(bySettingHour: 10, minute: 0, second: 0, of: sampleDate)!.timestamp)
        )
        
        var eventToKeep = Event(
            date: calendar.startOfDay(for: sampleDate),
            description: "Keep this event",
            endTimestamp: Int(calendar.date(bySettingHour: 16, minute: 0, second: 0, of: sampleDate)!.timestamp),
            plannerID: 1,
            memberIDs: [2, 3],
            title: "Keep Me",
            startTimestamp: Int(calendar.date(bySettingHour: 14, minute: 0, second: 0, of: sampleDate)!.timestamp)
        )
        
        eventToDelete.id = 1
        eventToKeep.id = 2
        UserDefaultsManager.saveEvents([eventToDelete, eventToKeep])
        
        GatherlyAPI.deleteEvent(eventToDelete)
            .sink { _ in 
                let storedEvents = UserDefaultsManager.loadEvents()
                XCTAssertEqual(storedEvents.count, 1)
                XCTAssertFalse(storedEvents.contains { $0.id == eventToDelete.id })
                XCTAssertTrue(storedEvents.contains { $0.id == eventToKeep.id })
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 2)
    }
}
