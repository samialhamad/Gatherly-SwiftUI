//
//  EventsViewModelTests.swift
//  Gatherly-SwiftUITests
//
//  Created by Sami Alhamad on 5/27/25.
//

import Combine
import XCTest
@testable import Gatherly_SwiftUI

final class EventsViewModelTests: XCTestCase {
    
//    var viewModel: EventsViewModel!
//    var cancellables: Set<AnyCancellable> = []
//    
//    override func setUp() {
//        super.setUp()
//        UserDefaultsManager.removeEvents()
//        viewModel = EventsViewModel()
//    }
//    
//    func makeSampleEvent(id: Int = 1, title: String = "Test Event") -> Event {
//        Event(
//            categories: [.entertainment],
//            date: Date(),
//            description: "Details",
//            endTimestamp: Int(Date().addingTimeInterval(3600).timestamp),
//            id: id,
//            plannerID: 1,
//            memberIDs: [2],
//            title: title,
//            startTimestamp: Int(Date().timestamp)
//        )
//    }
//    
//    func testLoadIfNeeded_onlyLoadsOnce() {
//        let event = makeSampleEvent(id: 1)
//        UserDefaultsManager.saveEvents([event])
//
//        let expectation = XCTestExpectation(description: "loadIfNeeded loads once")
//        var callCount = 0
//
//        viewModel.$events
//            .dropFirst()
//            .sink { loadedEvents in
//                callCount += 1
//                XCTAssertEqual(loadedEvents.count, 1)
//                XCTAssertEqual(loadedEvents.first?.id, 1)
//
//                // Trigger loadIfNeeded again — should not change anything
//                self.viewModel.loadIfNeeded()
//
//                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//                    XCTAssertEqual(callCount, 1, "Should only load once")
//                    expectation.fulfill()
//                }
//            }
//            .store(in: &cancellables)
//
//        viewModel.loadIfNeeded()
//        wait(for: [expectation], timeout: 3)
//    }
//    
//    func testCreate_addsEventToList() {
//        let expectation = XCTestExpectation(description: "Event is created and added")
//        
//        let event = makeSampleEvent(id: 345, title: "New Event")
//        viewModel.create(event) { created in
//            XCTAssertNotNil(created.id)
//            XCTAssertEqual(self.viewModel.events.count, 1)
//            XCTAssertEqual(self.viewModel.events.first?.title, "New Event")
//            expectation.fulfill()
//        }
//        
//        wait(for: [expectation], timeout: 3)
//    }
//    
//    func testUpdate_modifiesEventInList() {
//        let original = makeSampleEvent(id: 10, title: "Old Title")
//        UserDefaultsManager.saveEvents([original])
//        
//        let expectation = XCTestExpectation(description: "Event is updated in-place")
//        
//        viewModel.fetch()
//        
//        viewModel.$events
//            .dropFirst()
//            .sink { _ in
//                var updated = original
//                updated.title = "Updated Title"
//                self.viewModel.update(updated)
//                
//                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
//                    XCTAssertEqual(self.viewModel.events.count, 1)
//                    XCTAssertEqual(self.viewModel.events.first?.title, "Updated Title")
//                    expectation.fulfill()
//                }
//            }
//            .store(in: &cancellables)
//        
//        wait(for: [expectation], timeout: 4)
//    }
//    
//    func testDelete_removesEventFromList() {
//        let event1 = makeSampleEvent(id: 20)
//        let event2 = makeSampleEvent(id: 21)
//        UserDefaultsManager.saveEvents([event1, event2])
//        
//        let expectation = XCTestExpectation(description: "Event is deleted")
//        
//        viewModel.fetch()
//        
//        viewModel.$events
//            .dropFirst()
//            .sink { _ in
//                self.viewModel.delete(event1)
//                
//                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
//                    XCTAssertEqual(self.viewModel.events.count, 1)
//                    XCTAssertEqual(self.viewModel.events.first?.id, 21)
//                    expectation.fulfill()
//                }
//            }
//            .store(in: &cancellables)
//        
//        wait(for: [expectation], timeout: 4)
//    }
}
