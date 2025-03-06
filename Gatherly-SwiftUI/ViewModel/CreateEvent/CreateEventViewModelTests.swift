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
        
        let plannerID = 1
        let event = viewModel.createEvent(with: plannerID)
        
        XCTAssertEqual(event.title, "Test Event")
        XCTAssertEqual(event.description, "Test description")
        XCTAssertEqual(event.date, calendar.startOfDay(for: fixedDate))
        
        let expectedStartDate = calendar.date(from: DateComponents(year: 2025, month: 3, day: 5, hour: 10, minute: 0))!
        let expectedEndDate = calendar.date(from: DateComponents(year: 2025, month: 3, day: 5, hour: 12, minute: 0))!
        
        XCTAssertEqual(event.startTimestamp, Int(expectedStartDate.timeIntervalSince1970))
        XCTAssertEqual(event.endTimestamp, Int(expectedEndDate.timeIntervalSince1970))
        
        XCTAssertEqual(event.plannerID, plannerID)
        XCTAssertEqual(Set(event.memberIDs ?? []), Set([2, 3]))
    }
    
    func testClearFieldsResetsViewModel() {
        let viewModel = CreateEventViewModel()
        
        viewModel.title = "Something"
        viewModel.description = "Something"
        viewModel.selectedMemberIDs = Set([1, 2, 3])
        viewModel.selectedDate = Date(timeIntervalSince1970: 0)
        viewModel.startTime = Date(timeIntervalSince1970: 0)
        viewModel.endTime = Date(timeIntervalSince1970: 1000)
        
        viewModel.clearFields()
        
        XCTAssertEqual(viewModel.title, "")
        XCTAssertEqual(viewModel.description, "")
        XCTAssertTrue(viewModel.selectedMemberIDs.isEmpty)
        
        let now = Date()
        let tolerance: TimeInterval = 2.0
        XCTAssertLessThan(abs(viewModel.selectedDate.timeIntervalSince(now)), tolerance)
        XCTAssertLessThan(abs(viewModel.startTime.timeIntervalSince(now)), tolerance)
        XCTAssertLessThan(abs(viewModel.endTime.timeIntervalSince(now.addingTimeInterval(3600))), tolerance)
    }
}

