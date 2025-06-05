//
//  CreateEventTests.swift
//  Gatherly-SwiftUITests
//
//  Created by Sami Alhamad on 5/8/25.
//

import Combine
import XCTest
@testable import Gatherly_SwiftUI

final class CreateEventTests: XCTestCase {
    
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
    
    func testCreateEvent() {
        let expectation = XCTestExpectation(description: "Event creation completes")
        
        let fixedDate = calendar.date(from: DateComponents(year: 2025, month: 3, day: 5))!
        let startTime = calendar.date(bySettingHour: 10, minute: 0, second: 0, of: fixedDate)!
        let endTime = calendar.date(bySettingHour: 12, minute: 0, second: 0, of: fixedDate)!
        
        var event = Event()
        event.title = "New Event"
        event.description = "Description"
        event.startTimestamp = Int(startTime.timestamp)
        event.endTimestamp = Int(endTime.timestamp)
        event.memberIDs = [2, 3]
        event.categories = [.entertainment]
        event.bannerImageName = "test_banner.jpg"
        event.plannerID = 1
        
        GatherlyAPI.createEvent(event)
            .sink { createdEvent in
                XCTAssertEqual(createdEvent.title, "New Event")
                XCTAssertEqual(createdEvent.description, "Description")
                XCTAssertEqual(createdEvent.date, self.calendar.startOfDay(for: fixedDate))
                XCTAssertEqual(createdEvent.bannerImageName, "test_banner.jpg")
                
                let generatedID = createdEvent.id ?? 0
                XCTAssertGreaterThan(generatedID, 0)
                XCTAssertLessThanOrEqual(generatedID, Int(Date().timestamp))
                
                XCTAssertEqual(createdEvent.startTimestamp, Int(startTime.timestamp))
                XCTAssertEqual(createdEvent.endTimestamp, Int(endTime.timestamp))
                XCTAssertEqual(createdEvent.plannerID, 1)
                XCTAssertEqual(Set(createdEvent.memberIDs ?? []), Set([2, 3]))
                XCTAssertEqual(createdEvent.categories, [.entertainment])
                
                let loadedDict = UserDefaultsManager.loadEvents()
                
                XCTAssertEqual(loadedDict.count, 1)
                XCTAssertTrue(loadedDict.keys.contains(generatedID))
                
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 3)
    }
}
