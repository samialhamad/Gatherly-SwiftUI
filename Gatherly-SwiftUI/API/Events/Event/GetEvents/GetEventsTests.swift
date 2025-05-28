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
    
    func testGetEventsReturnsStoredEvents() {
        let expectation = XCTestExpectation(description: "Events are loaded from UserDefaults")
        
        let sampleDate = calendar.date(from: DateComponents(year: 2025, month: 3, day: 5))!
        let startTimestamp = Int(calendar.date(bySettingHour: 10, minute: 0, second: 0, of: sampleDate)!.timestamp)
        let endTimestamp = Int(calendar.date(bySettingHour: 12, minute: 0, second: 0, of: sampleDate)!.timestamp)
        
        let event = Event(
            categories: [.entertainment],
            date: sampleDate,
            description: "Event from UserDefaults",
            endTimestamp: endTimestamp,
            id: 123,
            plannerID: 1,
            memberIDs: [2, 3],
            title: "Loaded Event",
            startTimestamp: startTimestamp
        )
        
        UserDefaultsManager.saveEvents([event])
        
        GatherlyAPI.getEvents()
            .sink { events in
                XCTAssertEqual(events.count, 1)
                XCTAssertEqual(events.first?.title, "Loaded Event")
                XCTAssertEqual(events.first?.id, 123)
                XCTAssertEqual(events.first?.plannerID, 1)
                XCTAssertEqual(Set(events.first?.memberIDs ?? []), Set([2, 3]))
                XCTAssertEqual(events.first?.categories, [.entertainment])
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 3)
    }
}
