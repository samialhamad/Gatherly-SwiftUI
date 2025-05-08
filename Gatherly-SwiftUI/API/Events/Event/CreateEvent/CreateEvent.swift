//
//  CreateEvent.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 5/8/25.
//

import Foundation

extension GatherlyAPI {
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
        event.id = generateID()
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
}
