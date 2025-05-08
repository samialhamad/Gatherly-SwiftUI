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
        viewModel.title = "Test Event"
        viewModel.description = "Test description"
        viewModel.selectedDate = fixedDate
        viewModel.startTime = fixedStartTime
        viewModel.endTime = fixedEndTime
        viewModel.selectedMemberIDs = Set([2, 3])
        viewModel.selectedCategories = [.food, .sports]

        let testImage = UIImage(systemName: "photo")!
        viewModel.selectedBannerImage = testImage

        let plannerID = 1
        let event = await viewModel.createEvent(with: plannerID)

        let expectedStartTimestamp = Int(fixedStartTime.timestamp)
        let expectedEndTimestamp = Int(fixedEndTime.timestamp)

        XCTAssertEqual(event.title, "Test Event")
        XCTAssertEqual(event.description, "Test description")
        XCTAssertNotNil(event.id)
        XCTAssertEqual(event.date, calendar.startOfDay(for: fixedDate))
        XCTAssertEqual(event.startTimestamp, expectedStartTimestamp)
        XCTAssertEqual(event.endTimestamp, expectedEndTimestamp)
        XCTAssertEqual(event.plannerID, plannerID)
        XCTAssertEqual(Set(event.memberIDs ?? []), Set([2, 3]))
        XCTAssertEqual(event.categories, [.food, .sports])
        XCTAssertNotNil(event.bannerImageName)
        
        let allEvents = UserDefaultsManager.loadEvents()
        XCTAssertTrue(allEvents.contains(where: { $0.id == event.id }))
    }
    
    // MARK: - Clear Fields

    func testClearFields() {
        let viewModel = CreateEventViewModel()

        viewModel.title = "Something"
        viewModel.description = "Something"
        viewModel.selectedMemberIDs = Set([1, 2, 3])
        viewModel.selectedDate = Date(timeIntervalSince1970: 0)
        viewModel.startTime = Date(timeIntervalSince1970: 0)
        viewModel.endTime = Date(timeIntervalSince1970: 1000)
        viewModel.selectedCategories = [.travel, .networking]
        viewModel.selectedBannerImage = UIImage(systemName: "photo")!

        viewModel.clearFields()

        XCTAssertEqual(viewModel.title, "")
        XCTAssertEqual(viewModel.description, "")
        XCTAssertTrue(viewModel.selectedMemberIDs.isEmpty)
        XCTAssertTrue(viewModel.selectedCategories.isEmpty)
        XCTAssertNil(viewModel.selectedBannerImage)

        let now = Date()
        let tolerance: TimeInterval = 2.0
        XCTAssertLessThan(abs(viewModel.selectedDate.timeIntervalSince(now)), tolerance)
        XCTAssertLessThan(abs(viewModel.startTime.timeIntervalSince(now)), tolerance)
        XCTAssertLessThan(abs(viewModel.endTime.timeIntervalSince(now.addingTimeInterval(3600))), tolerance)
    }
    
    // MARK: isFormEmpty
    
    func testIsFormEmpty() {
        let viewModel = CreateEventViewModel()

        XCTAssertTrue(viewModel.isFormEmpty)

        viewModel.title = "   "
        XCTAssertTrue(viewModel.isFormEmpty)

        viewModel.title = "Birthday Bash"
        XCTAssertFalse(viewModel.isFormEmpty)
    }
}
