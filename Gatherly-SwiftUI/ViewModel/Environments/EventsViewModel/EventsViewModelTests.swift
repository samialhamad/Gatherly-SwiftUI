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
    
    var viewModel: EventsViewModel!
    var cancellables: Set<AnyCancellable> = []
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        UserDefaultsManager.removeEvents()
        viewModel = EventsViewModel()
        cancellables = []
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        cancellables = []
        UserDefaultsManager.removeEvents()
        try super.tearDownWithError()
    }
    
    private func saveSampleEventsToDefaults(_ events: [Event]) {
        let eventsDict = events.keyedBy(\.id)
        UserDefaultsManager.saveEvents(eventsDict)
    }
    
    private func makeSampleEvent(id: Int?) -> Event {
        let eventID = id ?? 0
        return Event(
            categories: [],
            date: Date(),
            description: "Sample Event \(eventID)",
            endTimestamp: Int((Date().plus(calendarComponent: .hour, value: 1) ?? Date()).timestamp),
            id: id,
            plannerID: 1,
            memberIDs: [],
            title: "Event \(eventID)",
            startTimestamp: Int(Date().timestamp)
        )
    }
    
    func testFetch() {
        let event1 = makeSampleEvent(id: 11)
        let event2 = makeSampleEvent(id: 99)
        
        saveSampleEventsToDefaults([event1, event2])
        
        let eventsLoaded = expectation(description: "fetch() should populate viewModel.events")
        
        var didSeeLoading = false
        
        viewModel.$isLoading
            .sink { isLoading in
                if isLoading {
                    didSeeLoading = true
                } else if didSeeLoading {
                    eventsLoaded.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.$events
            .dropFirst()
            .sink { loadedEvents in
                XCTAssertEqual(loadedEvents.count, 2)
                XCTAssertTrue(loadedEvents.contains(where: { $0.id == 11 }))
                XCTAssertTrue(loadedEvents.contains(where: { $0.id == 99 }))
            }
            .store(in: &cancellables)
        
        XCTAssertFalse(viewModel.isLoading)
        viewModel.fetch()
        
        wait(for: [eventsLoaded], timeout: 3.0)
        XCTAssertFalse(viewModel.isLoading)
    }
    
    func testCreate() {
        XCTAssertTrue(UserDefaultsManager.loadEvents().isEmpty)
        XCTAssertTrue(viewModel.events.isEmpty)
        
        let newEvent = makeSampleEvent(id: nil) // API will make one if needed
        let creationExpectation = expectation(description: "create() should append a new event")
        
        viewModel.$events
            .dropFirst()
            .sink { loadedEvents in
                XCTAssertEqual(loadedEvents.count, 1)
                XCTAssertEqual(loadedEvents.first?.title, newEvent.title)
                creationExpectation.fulfill()
            }
            .store(in: &cancellables)
        
        let loadingExpectation = expectation(description: "create() should toggle isLoading to false after creation")
        var didSeeLoadingOnCreate = false
        
        viewModel.$isLoading
            .sink { isLoading in
                if isLoading {
                    didSeeLoadingOnCreate = true
                } else if didSeeLoadingOnCreate {
                    loadingExpectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        XCTAssertFalse(viewModel.isLoading)
        
        viewModel.create(newEvent) { returnedEvent in
            let storedDict = UserDefaultsManager.loadEvents()
            XCTAssertEqual(storedDict.count, 1)
            XCTAssertEqual(storedDict.values.first?.title, newEvent.title)
        }
        
        wait(for: [creationExpectation, loadingExpectation], timeout: 3.0, enforceOrder: true)
        XCTAssertFalse(viewModel.isLoading)
    }
    
    func testUpdate() {
        let originalEvent = makeSampleEvent(id: 123)
        saveSampleEventsToDefaults([originalEvent])
        
        let fetchExpectation = expectation(description: "Initial fetch() to load the original event")
        
        viewModel.$events
            .dropFirst()
            .first(where: { loadedEvents in
                return loadedEvents.contains(where: { $0.id == 123 })
            })
            .sink { _ in
                fetchExpectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.fetch()
        wait(for: [fetchExpectation], timeout: 3.0)
        
        XCTAssertEqual(viewModel.events.count, 1)
        XCTAssertEqual(viewModel.events.first?.id, 123)
        
        var editedEvent = originalEvent
        editedEvent.title = "Updated Title"
        editedEvent.description = "Updated Description"
        
        let updateExpectation = expectation(description: "update() should replace the existing event in viewModel.events")
        
        viewModel.$events
            .dropFirst()
            .first(where: { loadedEvents in
                return loadedEvents.count == 1 &&
                loadedEvents.first?.title == "Updated Title" &&
                loadedEvents.first?.description == "Updated Description"
            })
            .sink { _ in
                updateExpectation.fulfill()
            }
            .store(in: &cancellables)
        
        XCTAssertFalse(viewModel.isLoading)
        
        viewModel.update(editedEvent)
        
        wait(for: [updateExpectation], timeout: 2.0)
        XCTAssertFalse(viewModel.isLoading)
        
        let storedDict = UserDefaultsManager.loadEvents()
        XCTAssertEqual(storedDict.count, 1)
        XCTAssertEqual(storedDict.values.first?.title, "Updated Title")
    }
    
    func testDeleteRemovesEvent() {
        let eventToDelete = makeSampleEvent(id: 555)
        saveSampleEventsToDefaults([eventToDelete])
        
        let fetchExpectation = expectation(description: "fetch() should load the event to delete")
        viewModel.$events
            .dropFirst()
            .sink { loadedEvents in
                if loadedEvents.contains(where: { $0.id == 555 }) {
                    fetchExpectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.fetch()
        
        wait(for: [fetchExpectation], timeout: 3.0)
        XCTAssertEqual(viewModel.events.count, 1)
        
        let deleteExpectation = expectation(description: "delete() success should remove the event from viewModel.events")
        
        viewModel.$events
            .dropFirst()
            .sink { loadedEvents in
                XCTAssertTrue(loadedEvents.isEmpty)
                deleteExpectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.delete(eventToDelete)
        
        wait(for: [deleteExpectation], timeout: 2.0)
        
        let persistedAfterDelete = UserDefaultsManager.loadEvents()
        XCTAssertTrue(persistedAfterDelete.isEmpty)
    }
}
