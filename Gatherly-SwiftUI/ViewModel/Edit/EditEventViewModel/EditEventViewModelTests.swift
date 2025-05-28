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
        return Event(
            date: Calendar.current.startOfDay(for: now),
            description: "Initial description",
            endTimestamp: Int(now.addingTimeInterval(7200).timestamp),
            id: 123,
            plannerID: 1,
            memberIDs: [2, 3],
            title: "Initial Title",
            startTimestamp: Int(now.addingTimeInterval(3600).timestamp)
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
        event.date = fixedDate
        event.startTimestamp = Int(expectedStart.timestamp)
        event.endTimestamp = Int(expectedEnd.timestamp)
        
        let viewModel = EditEventViewModel(event: event)
        viewModel.event.date = fixedDate
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
}
