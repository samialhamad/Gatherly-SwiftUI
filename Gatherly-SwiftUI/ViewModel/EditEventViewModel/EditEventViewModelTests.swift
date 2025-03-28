//
//  EditEventViewModelTests.swift
//  Gatherly-SwiftUITests
//
//  Created by Sami Alhamad on 3/5/25.
//

import XCTest
@testable import Gatherly_SwiftUI

final class EditEventViewModelTests: XCTestCase {
    
    func testUpdatedEventTitleAndDescription() {
        let calendar = Calendar.current
        let originalEvent = Event(
            date: calendar.startOfDay(for: Date()),
            description: "Initial description",
            endTimestamp: Int(Date().addingTimeInterval(7200).timestamp),
            id: 123,
            plannerID: 1,
            memberIDs: [2, 3],
            title: "Initial Title",
            startTimestamp: Int(Date().addingTimeInterval(3600).timestamp)
        )
        
        let viewModel = EditEventViewModel(event: originalEvent)
        viewModel.title = "Updated Title"
        viewModel.description = "Updated description"
        
        let updatedEvent = viewModel.updatedEvent()
        
        XCTAssertEqual(updatedEvent.title, "Updated Title")
        XCTAssertEqual(updatedEvent.description, "Updated description")
    }
    
    func testUpdatedEventDateAndTimeMerging() {
        let calendar = Calendar.current
        let fixedDate = calendar.date(from: DateComponents(year: 2025, month: 3, day: 5))!
        
        let now = Date()
        let originalEvent = Event(
            date: calendar.startOfDay(for: now),
            description: "Initial description",
            endTimestamp: Int(now.addingTimeInterval(7200).timestamp),
            id: 123,
            plannerID: 1,
            memberIDs: [2, 3],
            title: "Initial Title",
            startTimestamp: Int(now.addingTimeInterval(3600).timestamp)
        )
        
        let viewModel = EditEventViewModel(event: originalEvent)
        viewModel.selectedDate = fixedDate
        
        let startTime = calendar.date(from: DateComponents(hour: 10, minute: 0))!
        let endTime = calendar.date(from: DateComponents(hour: 12, minute: 0))!
        viewModel.startTime = startTime
        viewModel.endTime = endTime
        
        let updatedEvent = viewModel.updatedEvent()
        
        let mergedStart = calendar.date(bySettingHour: 10, minute: 0, second: 0, of: fixedDate)!
        let mergedEnd = calendar.date(bySettingHour: 12, minute: 0, second: 0, of: fixedDate)!
        
        XCTAssertEqual(updatedEvent.startTimestamp, Int(mergedStart.timestamp))
        XCTAssertEqual(updatedEvent.endTimestamp, Int(mergedEnd.timestamp))
        XCTAssertEqual(updatedEvent.date, calendar.startOfDay(for: fixedDate))
    }
    
    func testUpdatedEventMembers() {
        let calendar = Calendar.current
        let originalEvent = Event(
            date: calendar.startOfDay(for: Date()),
            description: "Initial description",
            endTimestamp: Int(Date().addingTimeInterval(7200).timestamp),
            id: 123,
            plannerID: 1,
            memberIDs: [2, 3],
            title: "Initial Title",
            startTimestamp: Int(Date().addingTimeInterval(3600).timestamp)
        )
        
        let viewModel = EditEventViewModel(event: originalEvent)
        viewModel.selectedMemberIDs = Set([2, 3, 4])
        
        let updatedEvent = viewModel.updatedEvent()
        
        XCTAssertEqual(Set(updatedEvent.memberIDs ?? []), Set([2, 3, 4]))
    }
    
    func testUpdatedEventCategories() {
        let calendar = Calendar.current
        let originalEvent = Event(
            categories: [.food],
            date: calendar.startOfDay(for: Date()),
            description: "Initial description",
            endTimestamp: Int(Date().addingTimeInterval(7200).timestamp),
            id: 123,
            plannerID: 1,
            memberIDs: [2, 3],
            title: "Initial Title",
            startTimestamp: Int(Date().addingTimeInterval(3600).timestamp)
        )
        
        let viewModel = EditEventViewModel(event: originalEvent)
        viewModel.selectedCategories = [.sports, .education]
        
        let updatedEvent = viewModel.updatedEvent()
        
        XCTAssertEqual(updatedEvent.categories, [.sports, .education])
    }
    
    func testUpdateEventBannerImage() {
            let calendar = Calendar.current
            let originalEvent = Event(
                bannerImageName: "old_banner.jpg",
                categories: [.food],
                date: calendar.startOfDay(for: Date()),
                description: "Initial description",
                endTimestamp: Int(Date().addingTimeInterval(7200).timestamp),
                id: 123,
                plannerID: 1,
                memberIDs: [2, 3],
                title: "Initial Title",
                startTimestamp: Int(Date().addingTimeInterval(3600).timestamp)
            )
            
            let viewModel = EditEventViewModel(event: originalEvent)
            viewModel.selectedBannerImage = UIImage(systemName: "star.fill")!
            
            let updatedEvent = viewModel.updatedEvent()
            
            XCTAssertNotNil(updatedEvent.bannerImageName) // using not nil here because of weird uUID string output, needs to change
        }
}
