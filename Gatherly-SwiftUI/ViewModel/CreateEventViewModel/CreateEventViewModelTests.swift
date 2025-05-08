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
        viewModel.event.date = fixedDate
        viewModel.event.startTimestamp = Int(fixedStartTime.timestamp)
        viewModel.event.endTimestamp = Int(fixedEndTime.timestamp)
        viewModel.event.memberIDs = [2, 3]
        viewModel.event.categories = [.food, .sports]
        viewModel.selectedBannerImage = UIImage(systemName: "photo")!

        let plannerID = 1
        let event = await viewModel.createEvent(plannerID: plannerID)

        XCTAssertEqual(event.title, "Test Event")
        XCTAssertEqual(event.description, "Test description")
        XCTAssertNotNil(event.id)
        XCTAssertEqual(event.date, calendar.startOfDay(for: fixedDate))
        XCTAssertEqual(event.startTimestamp, Int(fixedStartTime.timestamp))
        XCTAssertEqual(event.endTimestamp, Int(fixedEndTime.timestamp))
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

        viewModel.event.title = "Something"
        viewModel.event.description = "Something"
        viewModel.event.memberIDs = [1, 2, 3]
        viewModel.event.date = Date(timeIntervalSince1970: 0)
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

        let now = Date()
        let tolerance: TimeInterval = 2.0
        XCTAssertLessThan(abs((viewModel.event.date ?? Date()).timeIntervalSince(now)), tolerance)
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
}
