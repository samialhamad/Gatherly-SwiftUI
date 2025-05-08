//
//  UpdateEventTests.swift
//  Gatherly-SwiftUITests
//
//  Created by Sami Alhamad on 5/8/25.
//

import XCTest
@testable import Gatherly_SwiftUI

final class UpdateEventTests: XCTestCase {

    let calendar = Calendar.current

    override func setUp() {
        super.setUp()
        UserDefaultsManager.removeEvents()
    }
    
    func testUpdateEvent() async {
        let baseDate = calendar.date(from: DateComponents(year: 2025, month: 3, day: 5))!
        
        let original = await GatherlyAPI.createEvent(
            title: "Old Title",
            description: "Old Description",
            selectedDate: baseDate,
            startTime: calendar.date(bySettingHour: 10, minute: 0, second: 0, of: baseDate)!,
            endTime: calendar.date(bySettingHour: 12, minute: 0, second: 0, of: baseDate)!,
            selectedMemberIDs: [2],
            plannerID: 1,
            categories: [.entertainment],
            bannerImageName: "old_banner.jpg"
        )

        let newDate = calendar.date(from: DateComponents(year: 2025, month: 3, day: 6))!
        let updated = await GatherlyAPI.updateEvent(
            original,
            title: "Updated Title",
            description: "Updated Description",
            selectedDate: newDate,
            startTime: calendar.date(bySettingHour: 9, minute: 30, second: 0, of: newDate)!,
            endTime: calendar.date(bySettingHour: 11, minute: 0, second: 0, of: newDate)!,
            selectedMemberIDs: [2, 3],
            categories: [.food, .other],
            bannerImageName: "new_banner.jpg"
        )

        XCTAssertEqual(updated.title, "Updated Title")
        XCTAssertEqual(updated.description, "Updated Description")
        XCTAssertEqual(updated.date, calendar.startOfDay(for: newDate))

        let expectedStart = calendar.date(bySettingHour: 9, minute: 30, second: 0, of: newDate)!
        let expectedEnd = calendar.date(bySettingHour: 11, minute: 0, second: 0, of: newDate)!

        XCTAssertEqual(updated.startTimestamp, Int(expectedStart.timestamp))
        XCTAssertEqual(updated.endTimestamp, Int(expectedEnd.timestamp))
        XCTAssertEqual(Set(updated.memberIDs ?? []), Set([2, 3]))
        XCTAssertEqual(updated.plannerID, 1)
        XCTAssertEqual(updated.id, original.id)
        XCTAssertEqual(updated.categories, [.food, .other])
        XCTAssertEqual(updated.bannerImageName, "new_banner.jpg")
    }
}
