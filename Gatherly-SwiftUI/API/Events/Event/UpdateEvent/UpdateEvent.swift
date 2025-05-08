//
//  UpdateEvent.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 5/8/25.
//

import Foundation

extension GatherlyAPI {
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
}
