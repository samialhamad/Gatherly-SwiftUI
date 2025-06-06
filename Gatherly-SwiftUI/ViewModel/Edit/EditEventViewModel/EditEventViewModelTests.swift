//
//  EditEventViewModelTests.swift
//  Gatherly-SwiftUITests
//
//  Created by Sami Alhamad on 3/5/25.
//

import XCTest
@testable import Gatherly_SwiftUI

final class EditEventViewModelTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        UserDefaultsManager.removeEvents()
    }
    
    // Helper
    func makeSampleEvent() -> Event {
        let now = Date()
        let start = (now.plus(calendarComponent: .hour, value: 1) ?? now).timestamp
        let end   = (now.plus(calendarComponent: .hour, value: 2) ?? now).timestamp
        
        return Event(
            description: "Initial description",
            endTimestamp: Int(end),
            id: 123,
            plannerID: 1,
            memberIDs: [2, 3],
            title: "Initial Title",
            startTimestamp: Int(start)
        )
    }
    
    // MARK: - Update Event
    
    func testUpdateEvent_updatesTitle() async {
        let event = makeSampleEvent()
        let viewModel = EditEventViewModel(event: event)
        viewModel.event.title = "Updated Title"
        
        let updatedEvent = await viewModel.prepareUpdatedEvent()
        XCTAssertEqual(updatedEvent.title, "Updated Title")
    }
    
    func testUpdateEvent_updatesDescription() async {
        let event = makeSampleEvent()
        let viewModel = EditEventViewModel(event: event)
        viewModel.event.description = "Updated description"
        
        let updatedEvent = await viewModel.prepareUpdatedEvent()
        XCTAssertEqual(updatedEvent.description, "Updated description")
    }
    
    func testUpdateEvent_mergesUpdatedDateAndTimes() async {
        let calendar = Calendar.current
        let fixedDate = calendar.date(from: DateComponents(year: 2025, month: 3, day: 5))!
        let expectedStart = calendar.date(bySettingHour: 10, minute: 0, second: 0, of: fixedDate)!
        let expectedEnd = calendar.date(bySettingHour: 12, minute: 0, second: 0, of: fixedDate)!
        
        var event = makeSampleEvent()
        event.startTimestamp = Int(expectedStart.timestamp)
        event.endTimestamp = Int(expectedEnd.timestamp)
        
        let viewModel = EditEventViewModel(event: event)
        viewModel.event.startTimestamp = Int(expectedStart.timestamp)
        viewModel.event.endTimestamp = Int(expectedEnd.timestamp)
        
        let updatedEvent = await viewModel.prepareUpdatedEvent()
        XCTAssertEqual(updatedEvent.date, calendar.startOfDay(for: fixedDate))
        XCTAssertEqual(updatedEvent.startTimestamp, Int(expectedStart.timestamp))
        XCTAssertEqual(updatedEvent.endTimestamp, Int(expectedEnd.timestamp))
    }
    
    func testUpdateEvent_updatesMembers() async {
        let event = makeSampleEvent()
        let viewModel = EditEventViewModel(event: event)
        viewModel.event.memberIDs = [2, 3, 4]
        
        let updatedEvent = await viewModel.prepareUpdatedEvent()
        XCTAssertEqual(updatedEvent.memberIDs, [2, 3, 4])
    }
    
    func testUpdateEvent_updatesCategories() async {
        var event = makeSampleEvent()
        event.categories = [.food]
        
        let viewModel = EditEventViewModel(event: event)
        viewModel.event.categories = [.sports, .education]
        
        let updatedEvent = await viewModel.prepareUpdatedEvent()
        XCTAssertEqual(updatedEvent.categories, [.sports, .education])
    }
    
    func testUpdateEvent_handlesBannerImageSaving() async {
        var event = makeSampleEvent()
        event.bannerImageName = "old_banner.jpg"
        
        let viewModel = EditEventViewModel(event: event)
        viewModel.selectedBannerImage = UIImage(systemName: "star.fill")!
        
        let updatedEvent = await viewModel.prepareUpdatedEvent()
        XCTAssertNotNil(updatedEvent.bannerImageName)
    }
    
    // MARK: - isFormEmpty
    
    func testIsFormEmpty() {
        var event = makeSampleEvent()
        event.title = ""
        
        let viewModel = EditEventViewModel(event: event)
        XCTAssertTrue(viewModel.isFormEmpty)
        
        viewModel.event.title = "  "
        XCTAssertTrue(viewModel.isFormEmpty)
        
        viewModel.event.title = "Conference"
        XCTAssertFalse(viewModel.isFormEmpty)
    }
    
    // MARK: - startTime & endTime
    
    func testStartTime() {
        let calendar = Calendar.current
        let fixedDate = calendar.date(from: DateComponents(year: 2025, month: 3, day: 5))!
        let fixedTime = calendar.date(from: DateComponents(year: 2025, month: 3, day: 5, hour: 10, minute: 0))!
        
        // initializer will set selectedDate to start of day
        let initialEvent = Event(
            description: "Test",
            endTimestamp: nil,
            id: 42,
            plannerID: 1,
            memberIDs: [2],
            title: "Test",
            startTimestamp: Int(fixedTime.timestamp)
        )
        
        let viewModel = EditEventViewModel(event: initialEvent)
        
        // selectedDate should now be March 5, 2025 at midnight
        XCTAssertEqual(viewModel.selectedDate, Date.startOfDay(fixedDate))
        
        viewModel.startTime = fixedTime
        
        let expectedMerged = Date.merge(date: fixedDate, time: fixedTime)
        
        // event.startTimestamp must have become that merged timestamp
        XCTAssertEqual(viewModel.event.startTimestamp, Int(expectedMerged.timestamp))
        
        // startTime must return exactly that Date
        XCTAssertEqual(viewModel.startTime, expectedMerged)
    }
    
    func testEndTime() {
        let calendar = Calendar.current
        let fixedDate = calendar.date(from: DateComponents(year: 2025, month: 3, day: 5))!
        let fixedTime = calendar.date(from: DateComponents(year: 2025, month: 3, day: 5, hour: 15, minute: 30))!
        
        let initialEvent = Event(
            description: "Test",
            endTimestamp: Int(fixedTime.timestamp),
            id: 99,
            plannerID: 1,
            memberIDs: [2],
            title: "Test",
            startTimestamp: nil
        )
        let viewModel = EditEventViewModel(event: initialEvent)
                
        // have to explicitly set selectedDate here since its computed off startTimestamp usually
        viewModel.selectedDate = fixedDate
        viewModel.endTime = fixedTime
        
        let expectedMerged = Date.merge(date: fixedDate, time: fixedTime)
        
        // event.endTimestamp must have become that merged timestamp
        XCTAssertEqual(viewModel.event.endTimestamp, Int(expectedMerged.timestamp))
        
        // endTime must return exactly that Date
        XCTAssertEqual(viewModel.endTime, expectedMerged)
    }
    
    func testStartTime_whenTimestampIsNil_returnsNow() {
        let event = makeSampleEvent()
        var viewModel = EditEventViewModel(event: event)
        viewModel.event.startTimestamp = nil
        
        // abs since timeIntervalSinceNow can be negative, 1 second window
        let startTime = viewModel.startTime
        XCTAssertLessThan(abs(startTime.timeIntervalSinceNow), 1.0)
    }
    
    func testEndTime_whenTimestampIsNil_returnsNow() {
        let event = makeSampleEvent()
        var viewModel = EditEventViewModel(event: event)
        viewModel.event.endTimestamp = nil
        
        // abs since timeIntervalSinceNow can be negative, 1 second window
        let endTime = viewModel.endTime
        XCTAssertLessThan(abs(endTime.timeIntervalSinceNow), 1.0)
    }
}
