//
//  CreateEventViewModelTests.swift
//  Gatherly-SwiftUITests
//
//  Created by Sami Alhamad on 3/5/25.
//

import XCTest
@testable import Gatherly_SwiftUI

final class CreateEventViewModelTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        UserDefaultsManager.removeEvents()
    }
    
    // MARK: - Create Event
    
    func testCreateEvent() async {
        let calendar = Calendar.current
        let fixedDate = calendar.date(from: DateComponents(year: 2025, month: 3, day: 5))!
        let fixedStartTime = calendar.date(from: DateComponents(year: 2025, month: 3, day: 5, hour: 10, minute: 0))!
        let fixedEndTime = calendar.date(from: DateComponents(year: 2025, month: 3, day: 5, hour: 12, minute: 0))!
        
        let viewModel = CreateEventViewModel()
        viewModel.event.title = "Test Event"
        viewModel.event.description = "Test description"
        viewModel.event.startTimestamp = Int(fixedStartTime.timestamp)
        viewModel.event.endTimestamp = Int(fixedEndTime.timestamp)
        viewModel.event.memberIDs = [2, 3]
        viewModel.event.categories = [.food, .sports]
        viewModel.selectedBannerImage = UIImage(systemName: "photo")!
        
        let built = viewModel.builtEvent
        
        XCTAssertEqual(built.title, "Test Event")
        XCTAssertEqual(built.description, "Test description")
        XCTAssertEqual(built.date, calendar.startOfDay(for: fixedDate))
        XCTAssertEqual(built.startTimestamp, Int(fixedStartTime.timestamp))
        XCTAssertEqual(built.endTimestamp, Int(fixedEndTime.timestamp))
        XCTAssertEqual(built.plannerID, 1)
        XCTAssertEqual(built.memberIDs, [2, 3])
        XCTAssertEqual(built.categories, [.food, .sports])
        XCTAssertNotNil(built.bannerImageName)
    }
    
    // MARK: - Clear Fields
    
    func testClearFields() {
        let viewModel = CreateEventViewModel()
        
        viewModel.event.title = "Something"
        viewModel.event.description = "Something"
        viewModel.event.memberIDs = [1, 2, 3]
        viewModel.event.startTimestamp = 0
        viewModel.event.endTimestamp = 1000
        viewModel.event.categories = [.travel, .networking]
        viewModel.selectedBannerImage = UIImage(systemName: "photo")!
        
        viewModel.clearFields()
        
        XCTAssertEqual(viewModel.event.title, "")
        XCTAssertEqual(viewModel.event.description, "")
        XCTAssertEqual(viewModel.event.memberIDs ?? [], [])
        XCTAssertEqual(viewModel.event.categories, [])
        XCTAssertNil(viewModel.selectedBannerImage)
    }
    
    // MARK: isFormEmpty
    
    func testIsFormEmpty() {
        let viewModel = CreateEventViewModel()
        
        XCTAssertTrue(viewModel.isFormEmpty)
        
        viewModel.event.title = "   "
        XCTAssertTrue(viewModel.isFormEmpty)
        
        viewModel.event.title = "Birthday Bash"
        XCTAssertFalse(viewModel.isFormEmpty)
    }
    
    // MARK: - startTime & endTime
    
    func testStartTime() {
        let calendar = Calendar.current
        
        let fixedDateComponents = DateComponents(year: 2025, month: 3, day: 5)
        let fixedDate = calendar.date(from: fixedDateComponents)!
        
        let fixedTimeComponents = DateComponents(year: 2025, month: 3, day: 5, hour: 10, minute: 0)
        let fixedTime = calendar.date(from: fixedTimeComponents)!
        
        let viewModel = CreateEventViewModel()
        
        viewModel.selectedDate = fixedDate
        
        viewModel.startTime = fixedTime
        
        let expectedMergedStart = Date.merge(date: fixedDate, time: fixedTime)
        
        // confirm that event.startTimestamp is exactly the timestamp of expectedMergedStart:
        XCTAssertEqual(viewModel.event.startTimestamp, Int(expectedMergedStart.timestamp))
        // confirm the getter returns back the same Date
        XCTAssertEqual(viewModel.startTime, expectedMergedStart)
    }
    
    func testEndTime() {
        let calendar = Calendar.current
        
        let fixedDate = calendar.date(from: DateComponents(year: 2025, month: 3, day: 5))!
        let fixedTime = calendar.date(from: DateComponents(year: 2025, month: 3, day: 5, hour: 15, minute: 30))!
        
        let viewModel = CreateEventViewModel()
        viewModel.selectedDate = fixedDate
        
        viewModel.endTime = fixedTime
        
        let expectedMergedEnd = Date.merge(date: fixedDate, time: fixedTime)
        
        XCTAssertEqual(viewModel.event.endTimestamp, Int(expectedMergedEnd.timestamp))
        XCTAssertEqual(viewModel.endTime, expectedMergedEnd)
    }
    
    func testStartTime_whenTimestampIsNil_returnsNow() {
        let viewModel = CreateEventViewModel()
        viewModel.event.startTimestamp = nil
        let startTime = viewModel.startTime
        
        // abs since timeIntervalSinceNow can be negative, 1 second window
        XCTAssertLessThan(abs(startTime.timeIntervalSinceNow), 1.0)
    }
    
    func testEndTime_whenTimestampIsNil_returnsNow() {
        let viewModel = CreateEventViewModel()
        viewModel.event.endTimestamp = nil
        let endTime = viewModel.endTime
        
        // abs since timeIntervalSinceNow can be negative, 1 second window
        XCTAssertLessThan(abs(endTime.timeIntervalSinceNow), 1.0)
    }
}
