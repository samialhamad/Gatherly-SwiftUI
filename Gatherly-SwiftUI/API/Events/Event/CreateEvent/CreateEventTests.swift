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
        let startTime = calendar.date(bySettingHour: 10, minute: 0, second: 0, of: fixedDate)!
        let endTime = calendar.date(bySettingHour: 12, minute: 0, second: 0, of: fixedDate)!

        var event = Event()
        event.title = "New Event"
        event.description = "Description"
        event.date = fixedDate
        event.startTimestamp = Int(startTime.timestamp)
        event.endTimestamp = Int(endTime.timestamp)
        event.memberIDs = [2, 3]
        event.categories = [.entertainment]
        event.bannerImageName = "test_banner.jpg"
        event.plannerID = 1

        let createdEvent = await GatherlyAPI.createEvent(event)

        XCTAssertEqual(createdEvent.title, "New Event")
        XCTAssertEqual(createdEvent.description, "Description")
        XCTAssertEqual(createdEvent.date, calendar.startOfDay(for: fixedDate))
        XCTAssertEqual(createdEvent.bannerImageName, "test_banner.jpg")
        XCTAssertGreaterThan(createdEvent.id ?? 0, 0)
        XCTAssertLessThanOrEqual(createdEvent.id ?? 0, Int(Date().timestamp))

        XCTAssertEqual(createdEvent.startTimestamp, Int(startTime.timestamp))
        XCTAssertEqual(createdEvent.endTimestamp, Int(endTime.timestamp))
        XCTAssertEqual(createdEvent.plannerID, 1)
        XCTAssertEqual(Set(createdEvent.memberIDs ?? []), Set([2, 3]))
        XCTAssertEqual(createdEvent.categories, [.entertainment])
    }
}
