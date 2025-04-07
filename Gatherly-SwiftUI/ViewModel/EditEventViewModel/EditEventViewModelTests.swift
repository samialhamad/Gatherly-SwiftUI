//
//  EditEventViewModelTests.swift
//  Gatherly-SwiftUITests
//
//  Created by Sami Alhamad on 3/5/25.
//

import XCTest
@testable import Gatherly_SwiftUI

final class EditEventViewModelTests: XCTestCase {
    
    //helper function
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
    
    func testUpdatedEventTitle() {
        let viewModel = EditEventViewModel(event: makeSampleEvent())
        viewModel.title = "Updated Title"
        
        let updatedEvent = viewModel.updatedEvent()
        XCTAssertEqual(updatedEvent.title, "Updated Title")
    }
    
    func testUpdatedEventDescription() {
        let viewModel = EditEventViewModel(event: makeSampleEvent())
        viewModel.description = "Updated description"
        
        let updatedEvent = viewModel.updatedEvent()
        XCTAssertEqual(updatedEvent.description, "Updated description")
    }
    
    func testUpdatedEventDateAndTimeMerging() {
        let calendar = Calendar.current
        let fixedDate = calendar.date(from: DateComponents(year: 2025, month: 3, day: 5))!
        
        let viewModel = EditEventViewModel(event: makeSampleEvent())
        viewModel.selectedDate = fixedDate
        viewModel.startTime = calendar.date(from: DateComponents(hour: 10, minute: 0))!
        viewModel.endTime = calendar.date(from: DateComponents(hour: 12, minute: 0))!
        
        let updatedEvent = viewModel.updatedEvent()
        
        let expectedStart = calendar.date(bySettingHour: 10, minute: 0, second: 0, of: fixedDate)!
        let expectedEnd = calendar.date(bySettingHour: 12, minute: 0, second: 0, of: fixedDate)!
        
        XCTAssertEqual(updatedEvent.startTimestamp, Int(expectedStart.timestamp))
        XCTAssertEqual(updatedEvent.endTimestamp, Int(expectedEnd.timestamp))
        XCTAssertEqual(updatedEvent.date, calendar.startOfDay(for: fixedDate))
    }
    
    func testUpdatedEventMembers() {
        let viewModel = EditEventViewModel(event: makeSampleEvent())
        viewModel.selectedMemberIDs = Set([2, 3, 4])
        
        let updatedEvent = viewModel.updatedEvent()
        XCTAssertEqual(Set(updatedEvent.memberIDs ?? []), Set([2, 3, 4]))
    }
    
    func testUpdatedEventCategories() {
        var event = makeSampleEvent()
        event.categories = [.food]
        
        let viewModel = EditEventViewModel(event: event)
        viewModel.selectedCategories = [.sports, .education]
        
        let updatedEvent = viewModel.updatedEvent()
        XCTAssertEqual(updatedEvent.categories, [.sports, .education])
    }
    
    func testUpdateEventBannerImage() {
        var event = makeSampleEvent()
        event.bannerImageName = "old_banner.jpg"
        event.categories = [.food]
        
        let viewModel = EditEventViewModel(event: event)
        viewModel.selectedBannerImage = UIImage(systemName: "star.fill")!
        
        let updatedEvent = viewModel.updatedEvent()
        XCTAssertNotNil(updatedEvent.bannerImageName)
    }
}
