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
    
    var cancellables = Set<AnyCancellable>()
    
    override func setUp() {
        super.setUp()
        UserDefaultsManager.removeEvents()
    }
    
    override func tearDown() {
        UserDefaultsManager.removeEvents()
        super.tearDown()
    }
    
    func testDeleteEvent() {
        let expectation = XCTestExpectation(description: "Event is deleted and only the correct one remains")
        
        var eventToDelete = Event(id: 1, plannerID: 1, title: "Delete Me")
        var eventToKeep = Event(id: 2, plannerID: 1, title: "Keep Me")
        
        let initialDict: [Int: Event] = [
            eventToDelete.id!: eventToDelete,
            eventToKeep.id!: eventToKeep
        ]
        UserDefaultsManager.saveEvents(initialDict)
        
        GatherlyAPI.deleteEvent(eventToDelete)
            .sink { success in
                XCTAssertTrue(success, "Expected deleteEvent to return true")
                
                let loadedDict = UserDefaultsManager.loadEvents()
                
                XCTAssertEqual(loadedDict.count, 1)
                XCTAssertFalse(loadedDict.keys.contains(eventToDelete.id!))
                XCTAssertTrue(loadedDict.keys.contains(eventToKeep.id!))
                
                let keptEvent = loadedDict[eventToKeep.id!]
                XCTAssertEqual(keptEvent, eventToKeep)
                
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 2)
    }
    
    func testDeleteEventFailsForNonexistentEvent() {
        let expectation = XCTestExpectation(description: "Deletion should fail if event doesn't exist")
        
        let fakeEvent = Event(id: 999, plannerID: 1, title: "Fake")
        
        UserDefaultsManager.saveEvents([:])
        
        GatherlyAPI.deleteEvent(fakeEvent)
            .sink { success in
                XCTAssertFalse(success, "Expected deletion to fail")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
}
