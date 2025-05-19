//
//  DeleteEventTests.swift
//  Gatherly-SwiftUITests
//
//  Created by Sami Alhamad on 5/8/25.
//

import XCTest
@testable import Gatherly_SwiftUI

final class DeleteEventTests: XCTestCase {
    
    let calendar = Calendar.current
    
    override func setUp() {
        super.setUp()
        UserDefaultsManager.removeEvents()
    }
    
    func testDeleteEvent() async {
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
        
        eventToDelete = await GatherlyAPI.createEvent(eventToDelete)
        
        await GatherlyAPI.simulateNetworkDelay()
        
        var eventToKeep = Event(
            date: calendar.startOfDay(for: sampleDate),
            description: "Keep this event",
            endTimestamp: Int(calendar.date(bySettingHour: 16, minute: 0, second: 0, of: sampleDate)!.timestamp),
            plannerID: 1,
            memberIDs: [2, 3],
            title: "Keep Me",
            startTimestamp: Int(calendar.date(bySettingHour: 14, minute: 0, second: 0, of: sampleDate)!.timestamp)
        )
        
        eventToKeep = await GatherlyAPI.createEvent(eventToKeep)
        
        let updatedEvents = await GatherlyAPI.deleteEvent(eventToDelete)
        
        XCTAssertFalse(updatedEvents.contains(where: { $0.id == eventToDelete.id }))
        XCTAssertTrue(updatedEvents.contains(where: { $0.id == eventToKeep.id }))
        XCTAssertEqual(updatedEvents.count, 1)
    }
}
