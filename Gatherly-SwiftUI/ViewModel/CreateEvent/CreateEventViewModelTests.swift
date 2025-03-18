//
//  CreateEventViewModelTests.swift
//  Gatherly-SwiftUITests
//
//  Created by Sami Alhamad on 3/5/25.
//

import XCTest
@testable import Gatherly_SwiftUI

final class CreateEventViewModelTests: XCTestCase {
    
    func testCreateEvent() {
        let calendar = Calendar.current
        let fixedDate = calendar.date(from: DateComponents(year: 2025, month: 3, day: 5))!
        let fixedStartTime = calendar.date(from: DateComponents(hour: 10, minute: 0))!
        let fixedEndTime = calendar.date(from: DateComponents(hour: 12, minute: 0))!
        
        let viewModel = CreateEventViewModel()
        viewModel.title = "Test Event"
        viewModel.description = "Test description"
        viewModel.selectedDate = fixedDate
        viewModel.startTime = fixedStartTime
        viewModel.endTime = fixedEndTime
        viewModel.selectedMemberIDs = Set([2, 3])
        viewModel.selectedCategories = [.food, .sports]
        
        let plannerID = 1
        let event = viewModel.createEvent(with: plannerID)
        
        let expectedStartDate = calendar.date(from: DateComponents(year: 2025, month: 3, day: 5, hour: 10, minute: 0))!
        let expectedEndDate = calendar.date(from: DateComponents(year: 2025, month: 3, day: 5, hour: 12, minute: 0))!
        
        XCTAssertEqual(event.title, "Test Event")
        XCTAssertEqual(event.description, "Test description")
        XCTAssertEqual(event.date, calendar.startOfDay(for: fixedDate))
        XCTAssertEqual(event.startTimestamp, Int(expectedStartDate.timestamp))
        XCTAssertEqual(event.endTimestamp, Int(expectedEndDate.timestamp))
        XCTAssertEqual(event.plannerID, plannerID)
        XCTAssertEqual(Set(event.memberIDs ?? []), Set([2, 3]))
        XCTAssertEqual(event.categories, [.food, .sports])
    }
    
    func testClearFieldsResetsViewModel() {
        let viewModel = CreateEventViewModel()
        
        viewModel.title = "Something"
        viewModel.description = "Something"
        viewModel.selectedMemberIDs = Set([1, 2, 3])
        viewModel.selectedDate = Date(timeIntervalSince1970: 0)
        viewModel.startTime = Date(timeIntervalSince1970: 0)
        viewModel.endTime = Date(timeIntervalSince1970: 1000)
        viewModel.selectedCategories = [.travel, .networking]
        
        viewModel.clearFields()
        
        XCTAssertEqual(viewModel.title, "")
        XCTAssertEqual(viewModel.description, "")
        XCTAssertTrue(viewModel.selectedMemberIDs.isEmpty)
        XCTAssertTrue(viewModel.selectedCategories.isEmpty)
        
        //a small 2 second window to address this unit test failing as a result of time issues.
        let now = Date()
        let tolerance: TimeInterval = 2.0
        XCTAssertLessThan(abs(viewModel.selectedDate.timeIntervalSince(now)), tolerance)
        XCTAssertLessThan(abs(viewModel.startTime.timeIntervalSince(now)), tolerance)
        XCTAssertLessThan(abs(viewModel.endTime.timeIntervalSince(now.addingTimeInterval(3600))), tolerance)
    }
}

