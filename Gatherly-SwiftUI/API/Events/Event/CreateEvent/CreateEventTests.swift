//
//  CreateEventTests.swift
//  Gatherly-SwiftUITests
//
//  Created by Sami Alhamad on 5/8/25.
//

import XCTest
@testable import Gatherly_SwiftUI

final class CreateEventTests: XCTestCase {

    let calendar = Calendar.current

    override func setUp() {
        super.setUp()
        UserDefaultsManager.removeEvents()
    }

    func testCreateEvent() async {
        let fixedDate = calendar.date(from: DateComponents(year: 2025, month: 3, day: 5))!
        let startTime = calendar.date(from: DateComponents(hour: 10, minute: 0))!
        let endTime = calendar.date(from: DateComponents(hour: 12, minute: 0))!

        let createdEvent = await GatherlyAPI.createEvent(
            title: "New Event",
            description: "Description",
            selectedDate: fixedDate,
            startTime: startTime,
            endTime: endTime,
            selectedMemberIDs: Set([2, 3]),
            plannerID: 1,
            categories: [.entertainment],
            bannerImageName: "test_banner.jpg"
        )

        XCTAssertEqual(createdEvent.title, "New Event")
        XCTAssertEqual(createdEvent.description, "Description")
        XCTAssertEqual(createdEvent.date, calendar.startOfDay(for: fixedDate))
        XCTAssertEqual(createdEvent.bannerImageName, "test_banner.jpg")
        XCTAssertGreaterThan(createdEvent.id ?? 0, 0)
        XCTAssertLessThanOrEqual(createdEvent.id ?? 0, Int(Date().timestamp))

        let expectedStart = calendar.date(bySettingHour: 10, minute: 0, second: 0, of: fixedDate)!
        let expectedEnd = calendar.date(bySettingHour: 12, minute: 0, second: 0, of: fixedDate)!

        XCTAssertEqual(createdEvent.startTimestamp, Int(expectedStart.timestamp))
        XCTAssertEqual(createdEvent.endTimestamp, Int(expectedEnd.timestamp))
        XCTAssertEqual(createdEvent.plannerID, 1)
        XCTAssertEqual(Set(createdEvent.memberIDs ?? []), Set([2, 3]))
        XCTAssertEqual(createdEvent.categories, [.entertainment])
    }
}
