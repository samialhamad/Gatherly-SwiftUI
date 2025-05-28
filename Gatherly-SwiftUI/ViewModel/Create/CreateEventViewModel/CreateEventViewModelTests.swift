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
