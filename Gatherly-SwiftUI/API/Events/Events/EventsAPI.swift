//
//  EventsAPI.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 5/7/25.
//

import Foundation

extension GatherlyAPI {
    
    // MARK: - Create Event
    
    static func createEvent(
        title: String,
        description: String,
        selectedDate: Date,
        startTime: Date,
        endTime: Date,
        selectedMemberIDs: Set<Int>,
        plannerID: Int,
        location: Location? = nil,
        categories: [EventCategory] = [],
        bannerImageName: String? = nil
    ) async -> Event {
        let calendar = Calendar.current
        let mergedStart = Date.merge(date: selectedDate, time: startTime)
        let mergedEnd = Date.merge(date: selectedDate, time: endTime)

        var event = Event()
        event.id = generateNextEventID()
        event.plannerID = plannerID
        event.title = title
        event.description = description
        event.startTimestamp = Int(mergedStart.timestamp)
        event.endTimestamp = Int(mergedEnd.timestamp)
        event.date = calendar.startOfDay(for: selectedDate)
        event.memberIDs = Array(selectedMemberIDs).sorted()
        event.location = location
        event.categories = categories
        event.bannerImageName = bannerImageName

        var events = UserDefaultsManager.loadEvents()
        events.append(event)
        UserDefaultsManager.saveEvents(events)

        await simulateNetworkDelay()
        return event
    }

    // MARK: - Update Event
    
    static func updateEvent(
        _ originalEvent: Event,
        title: String,
        description: String,
        selectedDate: Date,
        startTime: Date,
        endTime: Date,
        selectedMemberIDs: Set<Int>,
        location: Location? = nil,
        categories: [EventCategory] = [],
        bannerImageName: String? = nil
    ) async -> Event {
        let calendar = Calendar.current
        let mergedStart = Date.merge(date: selectedDate, time: startTime)
        let mergedEnd = Date.merge(date: selectedDate, time: endTime)

        var updatedEvent = originalEvent
        updatedEvent.title = title
        updatedEvent.description = description
        updatedEvent.startTimestamp = Int(mergedStart.timestamp)
        updatedEvent.endTimestamp = Int(mergedEnd.timestamp)
        updatedEvent.date = calendar.startOfDay(for: selectedDate)
        updatedEvent.memberIDs = Array(selectedMemberIDs).sorted()
        updatedEvent.location = location
        updatedEvent.categories = categories
        updatedEvent.bannerImageName = bannerImageName

        var events = UserDefaultsManager.loadEvents()
        if let index = events.firstIndex(where: { $0.id == originalEvent.id }) {
            events[index] = updatedEvent
            UserDefaultsManager.saveEvents(events)
        }

        await simulateNetworkDelay()
        return updatedEvent
    }

    // MARK: - Delete Event

    static func deleteEvent(_ eventToDelete: Event) async -> [Event] {
        var events = UserDefaultsManager.loadEvents()
        
        events.removeAll { $0.id == eventToDelete.id }
        UserDefaultsManager.saveEvents(events)
        
        await simulateNetworkDelay()
        return events
    }

    // MARK: - ID Generation

    private static func generateNextEventID() -> Int {
        Int(Date().timestamp)
    }
    
    // MARK: - Simulate Delay
    
    private static func simulateNetworkDelay(seconds: Double = 1.0) async {
        let ns = UInt64(seconds * 1_000_000_000) // 1 second
        try? await Task.sleep(nanoseconds: ns)
    }
}
