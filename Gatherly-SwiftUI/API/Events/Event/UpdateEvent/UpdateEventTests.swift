//
//  UpdateEventTests.swift
//  Gatherly-SwiftUITests
//
//  Created by Sami Alhamad on 5/8/25.
//

import Combine
import XCTest
@testable import Gatherly_SwiftUI

final class UpdateEventTests: XCTestCase {
    
    let calendar = Calendar.current
    var cancellables = Set<AnyCancellable>()
    
    override func setUp() {
        super.setUp()
        UserDefaultsManager.removeEvents()
    }
    
    override func tearDown() {
        UserDefaultsManager.removeEvents()
        super.tearDown()
    }
    
    func testUpdateEvent() {
        let expectation = XCTestExpectation(description: "Event is updated correctly")
        
        let originalDate = calendar.date(from: DateComponents(year: 2025, month: 3, day: 5))!
        let originalStart = calendar.date(bySettingHour: 10, minute: 0, second: 0, of: originalDate)!
        let originalEnd = calendar.date(bySettingHour: 12, minute: 0, second: 0, of: originalDate)!
        
        var event = Event(
            bannerImageName: "old_banner.jpg",
            categories: [.entertainment],
            description: "Old Description",
            endTimestamp: Int(originalEnd.timestamp),
            id: 101,
            plannerID: 1,
            memberIDs: [2],
            title: "Old Title",
            startTimestamp: Int(originalStart.timestamp)
        )
        
        UserDefaultsManager.saveEvents([event.id!: event])
        
        let updatedDate = calendar.date(from: DateComponents(year: 2025, month: 3, day: 6))!
        let updatedStart = calendar.date(bySettingHour: 9, minute: 30, second: 0, of: updatedDate)!
        let updatedEnd = calendar.date(bySettingHour: 11, minute: 0, second: 0, of: updatedDate)!
        
        event.title = "Updated Title"
        event.description = "Updated Description"
        event.startTimestamp = Int(updatedStart.timestamp)
        event.endTimestamp = Int(updatedEnd.timestamp)
        event.memberIDs = [2, 3]
        event.categories = [.food, .other]
        event.bannerImageName = "new_banner.jpg"
        
        GatherlyAPI.updateEvent(event)
            .sink { updatedEvent in
                XCTAssertEqual(updatedEvent.title, "Updated Title")
                XCTAssertEqual(updatedEvent.description, "Updated Description")
                XCTAssertEqual(updatedEvent.date, self.calendar.startOfDay(for: updatedDate))
                XCTAssertEqual(updatedEvent.startTimestamp, Int(updatedStart.timestamp))
                XCTAssertEqual(updatedEvent.endTimestamp, Int(updatedEnd.timestamp))
                XCTAssertEqual(Set(updatedEvent.memberIDs ?? []), Set([2, 3]))
                XCTAssertEqual(updatedEvent.categories, [.food, .other])
                XCTAssertEqual(updatedEvent.bannerImageName, "new_banner.jpg")
                XCTAssertEqual(updatedEvent.plannerID, 1)
                XCTAssertEqual(updatedEvent.id, 101)
                
                let storedDict = UserDefaultsManager.loadEvents()
                
                XCTAssertEqual(storedDict.count, 1)
                XCTAssertTrue(storedDict.keys.contains(101))
                
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: TimeInterval(GatherlyAPI.delayTime))
    }
}
