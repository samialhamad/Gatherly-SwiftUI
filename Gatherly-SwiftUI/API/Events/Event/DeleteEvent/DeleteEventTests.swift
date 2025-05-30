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
                
        var eventToDelete = Event(id: 1, plannerID: 1, title: "Delete Me")
        var eventToKeep = Event(id: 2, plannerID: 1, title: "Keep Me")
        
        UserDefaultsManager.saveEvents([eventToDelete, eventToKeep])
        
        GatherlyAPI.deleteEvent(eventToDelete)
            .sink { success in
                XCTAssertTrue(success, "Expected deleteEvent to return true")

                let storedEvents = UserDefaultsManager.loadEvents()
                
                XCTAssertEqual(storedEvents.count, 1)
                XCTAssertFalse(storedEvents.contains { $0.id == eventToDelete.id })
                XCTAssertTrue(storedEvents.contains { $0.id == eventToKeep.id })
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 2)
    }
    
    func testDeleteEventFailsForNonexistentEvent() {
        let expectation = XCTestExpectation(description: "Deletion should fail if event doesn't exist")

        let fakeEvent = Event(id: 999, plannerID: 1, title: "Fake")
        UserDefaultsManager.saveEvents([])

        GatherlyAPI.deleteEvent(fakeEvent)
            .sink { success in
                XCTAssertFalse(success, "Expected deletion to fail")
                expectation.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1)
    }
}
