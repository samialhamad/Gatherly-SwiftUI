//
//  GetEventsTests.swift
//  Gatherly-SwiftUITests
//
//  Created by Sami Alhamad on 5/27/25.
//

import Combine
import XCTest
@testable import Gatherly_SwiftUI

final class GetEventsTests: XCTestCase {
    
    var cancellables = Set<AnyCancellable>()
    let calendar = Calendar.current
    
    override func setUp() {
        super.setUp()
        UserDefaultsManager.removeEvents()
    }
    
    override func tearDown() {
        UserDefaultsManager.removeEvents()
        super.tearDown()
    }
    
    private func makeEvent(
        id: Int,
        title: String,
        description: String
    ) -> Event {
        let sampleDate = calendar.date(from: DateComponents(year: 2025, month: 3, day: 5))!
        let startTimestamp = Int(calendar.date(bySettingHour: 10, minute: 0, second: 0, of: sampleDate)!.timestamp)
        let endTimestamp = Int(calendar.date(bySettingHour: 12, minute: 0, second: 0, of: sampleDate)!.timestamp)
        
        return Event(
            categories: [.entertainment],
            description: description,
            endTimestamp: endTimestamp,
            id: id,
            plannerID: 1,
            memberIDs: [2, 3],
            title: title,
            startTimestamp: startTimestamp
        )
    }
    
    func testGetEventsReturnsNoEvents() {
        let expectation = XCTestExpectation(description: "No Events are loaded from UserDefaults")
        
        GatherlyAPI.getEvents()
            .sink { events in
                XCTAssertEqual(events.count, 0)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 3)
    }
    
    func testGetEventsReturnsStoredEvent() {
        let expectation = XCTestExpectation(description: "Events are loaded from UserDefaults")
        
        let event = makeEvent(
            id: 123,
            title: "Loaded Event",
            description: "Event from UserDefaults"
        )
        
        UserDefaultsManager.saveEvents([event.id!: event])
        
        GatherlyAPI.getEvents()
            .sink { events in
                XCTAssertEqual(events.count, 1)
                XCTAssertEqual(events.first?.title, "Loaded Event")
                XCTAssertEqual(events.first?.id, 123)
                XCTAssertEqual(events.first?.plannerID, 1)
                XCTAssertEqual(Set(events.first?.memberIDs ?? []), Set([2, 3]))
                XCTAssertEqual(events.first?.categories, [.entertainment])
                
                let sampleDate = self.calendar.date(from: DateComponents(year: 2025, month: 3, day: 5))!
                XCTAssertEqual(events.first?.date, self.calendar.startOfDay(for: sampleDate))
                
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 3)
    }
    
    func testGetEventsReturnsStoredEvents() {
        let expectation = XCTestExpectation(description: "Two Events are loaded from UserDefaults")
        
        let event1 = makeEvent(
            id: 123,
            title: "Loaded Event 1",
            description: "Event 1 from UserDefaults"
        )
        let event2 = makeEvent(
            id: 333,
            title: "Loaded Event 2",
            description: "Event 2 from UserDefaults"
        )
        
        UserDefaultsManager.saveEvents([
            event1.id!: event1,
            event2.id!: event2
        ])
        
        GatherlyAPI.getEvents()
            .sink { events in
                XCTAssertEqual(events.count, 2)
                let sorted = events.sorted { ($0.id ?? 0) < ($1.id ?? 0) }
                
                let first = sorted[0]
                XCTAssertEqual(first.title, "Loaded Event 1")
                XCTAssertEqual(first.id, 123)
                XCTAssertEqual(first.plannerID, 1)
                XCTAssertEqual(Set(first.memberIDs ?? []), Set([2, 3]))
                XCTAssertEqual(first.categories, [.entertainment])
                let sampleDate = self.calendar.date(from: DateComponents(year: 2025, month: 3, day: 5))!
                XCTAssertEqual(first.date, self.calendar.startOfDay(for: sampleDate))
                
                let second = sorted[1]
                XCTAssertEqual(second.title, "Loaded Event 2")
                XCTAssertEqual(second.id, 333)
                XCTAssertEqual(second.plannerID, 1)
                XCTAssertEqual(Set(second.memberIDs ?? []), Set([2, 3]))
                XCTAssertEqual(second.categories, [.entertainment])
                XCTAssertEqual(second.date, self.calendar.startOfDay(for: sampleDate))
                
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 3)
    }
}
