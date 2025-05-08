//
//  EventsAPITests.swift
//  Gatherly-SwiftUITests
//
//  Created by Sami Alhamad on 5/7/25.
//

import XCTest
@testable import Gatherly_SwiftUI

final class EventsAPITests: XCTestCase {
    
    let calendar = Calendar.current

    override func setUp() {
        super.setUp()
        UserDefaultsManager.removeEvents()
    }

    // MARK: - Create Event

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

    // MARK: - Update Event

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

    // MARK: - Delete Event

    func testDeleteEvent_removesEventFromStorage() async {
        let sampleDate = calendar.date(from: DateComponents(year: 2025, month: 3, day: 5))!

        let eventToDelete = await GatherlyAPI.createEvent(
            title: "Delete Me",
            description: "Event to delete",
            selectedDate: sampleDate,
            startTime: calendar.date(bySettingHour: 10, minute: 0, second: 0, of: sampleDate)!,
            endTime: calendar.date(bySettingHour: 12, minute: 0, second: 0, of: sampleDate)!,
            selectedMemberIDs: [2, 3],
            plannerID: 1
        )
        
        try? await Task.sleep(nanoseconds: 1_000_000_000) // addresses same ID events failing this test

        let eventToKeep = await GatherlyAPI.createEvent(
            title: "Keep Me",
            description: "Keep this event",
            selectedDate: sampleDate,
            startTime: calendar.date(bySettingHour: 14, minute: 0, second: 0, of: sampleDate)!,
            endTime: calendar.date(bySettingHour: 16, minute: 0, second: 0, of: sampleDate)!,
            selectedMemberIDs: [2, 3],
            plannerID: 1
        )
        
        let updatedEvents = await GatherlyAPI.deleteEvent(eventToDelete)

        XCTAssertFalse(updatedEvents.contains(where: { $0.id == eventToDelete.id }))
        XCTAssertTrue(updatedEvents.contains(where: { $0.id == eventToKeep.id }))
        XCTAssertEqual(updatedEvents.count, 1)
    }
}
