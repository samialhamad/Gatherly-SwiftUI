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
    
    func testDeleteEvent_removesEventFromStorage() async {
        let sampleDate = calendar.date(from: DateComponents(year: 2025, month: 3, day: 5))!
        
        let eventToDelete = await GatherlyAPI.createEvent(
            title: "Delete Me",
            description: "Event to delete",
            selectedDate: sampleDate,
            startTime: calendar.date(bySettingHour: 10, minute: 0, second: 0, of: sampleDate)!,
            endTime: calendar.date(bySettingHour: 12, minute: 0, second: 0, of: sampleDate)!,
            selectedMemberIDs: [2, 3],
            plannerID: 1
        )
        
        try? await Task.sleep(nanoseconds: 1_000_000_000) // addresses same ID events failing this test
        
        let eventToKeep = await GatherlyAPI.createEvent(
            title: "Keep Me",
            description: "Keep this event",
            selectedDate: sampleDate,
            startTime: calendar.date(bySettingHour: 14, minute: 0, second: 0, of: sampleDate)!,
            endTime: calendar.date(bySettingHour: 16, minute: 0, second: 0, of: sampleDate)!,
            selectedMemberIDs: [2, 3],
            plannerID: 1
        )
        
        let updatedEvents = await GatherlyAPI.deleteEvent(eventToDelete)
        
        XCTAssertFalse(updatedEvents.contains(where: { $0.id == eventToDelete.id }))
        XCTAssertTrue(updatedEvents.contains(where: { $0.id == eventToKeep.id }))
        XCTAssertEqual(updatedEvents.count, 1)
    }
}
