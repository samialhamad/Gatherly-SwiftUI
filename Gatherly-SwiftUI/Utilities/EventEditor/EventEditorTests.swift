//
//  EventEditorTests.swift
//  Gatherly-SwiftUITests
//
//  Created by Sami Alhamad on 3/6/25.
//

import XCTest
@testable import Gatherly_SwiftUI

final class EventEditorTests: XCTestCase {
    
    let calendar = Calendar.current
    
    //MARK: - Create Event
    
    func testCreateEvent() {
        let fixedDate = calendar.date(from: DateComponents(year: 2025, month: 3, day: 5))!
        let startTime = calendar.date(from: DateComponents(hour: 10, minute: 0, second: 0))!
        let endTime = calendar.date(from: DateComponents(hour: 12, minute: 0, second: 0))!
        
        let createdEvent = EventEditor.saveEvent(
            title: "New Event",
            description: "Description",
            selectedDate: fixedDate,
            startTime: startTime,
            endTime: endTime,
            selectedMemberIDs: Set([2, 3]),
            plannerID: 1,
            generateEventID: { 101 }  // Fixed id for testing sake
        )
        
        XCTAssertEqual(createdEvent.title, "New Event")
        XCTAssertEqual(createdEvent.description, "Description")
        XCTAssertEqual(createdEvent.date, calendar.startOfDay(for: fixedDate))
        
        let expectedStart = calendar.date(from: DateComponents(year: 2025, month: 3, day: 5, hour: 10, minute: 0, second: 0))!
        let expectedEnd = calendar.date(from: DateComponents(year: 2025, month: 3, day: 5, hour: 12, minute: 0, second: 0))!
        
        XCTAssertEqual(createdEvent.startTimestamp, Int(expectedStart.timestamp))
        XCTAssertEqual(createdEvent.endTimestamp, Int(expectedEnd.timestamp))
        XCTAssertEqual(createdEvent.plannerID, 1)
        XCTAssertEqual(Set(createdEvent.memberIDs ?? []), Set([2, 3]))
        XCTAssertEqual(createdEvent.id, 101)
    }
    
    //MARK: - Update Event
    
    func testUpdateEvent() {
        let baseDate = calendar.date(from: DateComponents(year: 2025, month: 3, day: 5))!
        let originalEvent = Event(
            date: calendar.startOfDay(for: baseDate),
            description: "Old Description",
            endTimestamp: Int(baseDate.addingTimeInterval(7200).timestamp),
            id: 123,
            plannerID: 1,
            memberIDs: [2],
            title: "Old Title",
            startTimestamp: Int(baseDate.addingTimeInterval(3600).timestamp)
        )
        
        let newFixedDate = calendar.date(from: DateComponents(year: 2025, month: 3, day: 6))!
        let newStartTime = calendar.date(from: DateComponents(hour: 9, minute: 30, second: 0))!
        let newEndTime = calendar.date(from: DateComponents(hour: 11, minute: 0, second: 0))!
        
        let updatedEvent = EventEditor.saveEvent(
            originalEvent: originalEvent,
            title: "Updated Title",
            description: "Updated Description",
            selectedDate: newFixedDate,
            startTime: newStartTime,
            endTime: newEndTime,
            selectedMemberIDs: Set([2, 3]),
            plannerID: 1
        )
        
        XCTAssertEqual(updatedEvent.title, "Updated Title")
        XCTAssertEqual(updatedEvent.description, "Updated Description")
        XCTAssertEqual(updatedEvent.date, calendar.startOfDay(for: newFixedDate))
        
        let expectedStart = calendar.date(from: DateComponents(year: 2025, month: 3, day: 6, hour: 9, minute: 30, second: 0))!
        let expectedEnd = calendar.date(from: DateComponents(year: 2025, month: 3, day: 6, hour: 11, minute: 0, second: 0))!
        
        XCTAssertEqual(updatedEvent.startTimestamp, Int(expectedStart.timestamp))
        XCTAssertEqual(updatedEvent.endTimestamp, Int(expectedEnd.timestamp))
        XCTAssertEqual(updatedEvent.memberIDs, [2, 3])
        // The plannerID and id remain unchanged when updating event
        XCTAssertEqual(updatedEvent.plannerID, 1)
        XCTAssertEqual(updatedEvent.id, 123)
    }
    
    //MARK: - Delete Event
    
    func testDeleteEvent_RemovesEventAndReturnsDate() {
        let sampleDate = calendar.date(from: DateComponents(year: 2025, month: 3, day: 5))!
        
        let eventToDelete = Event(
            date: calendar.startOfDay(for: sampleDate),
            description: "Event to delete",
            endTimestamp: Int(sampleDate.addingTimeInterval(7200).timestamp),
            id: 101,
            plannerID: 1,
            memberIDs: [2, 3],
            title: "Delete Me",
            startTimestamp: Int(sampleDate.addingTimeInterval(3600).timestamp)
        )
        
        let eventToStay = Event(
            date: calendar.startOfDay(for: sampleDate),
            description: "Keep this event",
            endTimestamp: Int(sampleDate.addingTimeInterval(7200).timestamp),
            id: 102,
            plannerID: 1,
            memberIDs: [2, 3],
            title: "Keep Me",
            startTimestamp: Int(sampleDate.addingTimeInterval(3600).timestamp)
        )
        
        let events = [eventToDelete, eventToStay]
        
        let (updatedEvents, newSelectedDate) = EventEditor.deleteEvent(from: events, eventToDelete: eventToDelete)
        
        // check eventToDelete is removed by id
        XCTAssertFalse(updatedEvents.contains { $0.id == eventToDelete.id })
        // check newSelectedDate equals the deleted event's date, since the UI will stay on that date
        XCTAssertEqual(newSelectedDate, eventToDelete.date)
        XCTAssertEqual(updatedEvents.count, 1)
    }
    
    //MARK: - isFormEmpty
    
    func testIsFormEmptyTitleAndDescriptionEmpty() {
        let result = EventEditor.isFormEmpty(title: "", description: "")
        XCTAssertTrue(result)
    }
    
    func testIsFormEmptyTitleEmpty() {
        let result = EventEditor.isFormEmpty(title: "   ", description: "description")
        XCTAssertTrue(result)
    }
    
    func testIsFormEmptyDescriptionEmpty() {
        let result = EventEditor.isFormEmpty(title: " title ", description: "")
        XCTAssertTrue(result)
    }
    
    func testIsFormEmptyValidTitleAndDescription() {
        let result = EventEditor.isFormEmpty(title: "Title", description: "description")
        XCTAssertFalse(result)
    }
}
