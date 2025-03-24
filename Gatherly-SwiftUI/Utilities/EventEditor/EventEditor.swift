//
//  EventEditor.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/6/25.
//

import Foundation
import SwiftUI

struct EventEditor {
    
    //MARK: - Save / Edit
    
    static func saveEvent(
        originalEvent: Event? = nil,
        title: String,
        description: String,
        selectedDate: Date,
        startTime: Date,
        endTime: Date,
        selectedMemberIDs: Set<Int>,
        plannerID: Int,
        location: Location? = nil,
        categories: [Brand.EventCategory] = [],
        bannerImageName: String? = nil,
        generateEventID: () -> Int = { Int.random(in: 1000...9999) } //for now, random int generation for the id
    ) -> Event {
        let calendar = Calendar.current
        let mergedStart = Date.merge(date: selectedDate, time: startTime)
        let mergedEnd = Date.merge(date: selectedDate, time: endTime)
        
        var event = Event()
        
        if let originalEvent = originalEvent {
            event.plannerID = originalEvent.plannerID
            event.id = originalEvent.id
        } else {
            event.plannerID = plannerID
            event.id = generateEventID()
        }
        
        event.title = title
        event.description = description
        event.startTimestamp = Int(mergedStart.timestamp)
        event.endTimestamp = Int(mergedEnd.timestamp)
        event.date = calendar.startOfDay(for: selectedDate)
        event.memberIDs = Array(selectedMemberIDs).sorted()
        event.location = location
        event.categories = categories
        event.bannerImageName = bannerImageName
        
        return event
    }
    
    //MARK: - Delete
    
    static func deleteEvent(from events: [Event], eventToDelete: Event) -> ([Event], Date) {
        var updatedEvents = events
        if let index = updatedEvents.firstIndex(where: { $0.id == eventToDelete.id }) {
            updatedEvents.remove(at: index)
        }
        let newSelectedDate = eventToDelete.date ?? Date()
        return (updatedEvents, newSelectedDate)
    }
    
    //MARK: - isFormEmpty
    
    static func isFormEmpty(title: String, description: String) -> Bool {
        title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
