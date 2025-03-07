//
//  EventEditor.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/6/25.
//

import Foundation
import SwiftUI

struct EventEditor {
    static func saveEvent(
        originalEvent: Event? = nil,
        title: String,
        description: String,
        selectedDate: Date,
        startTime: Date,
        endTime: Date,
        selectedMemberIDs: Set<Int>,
        plannerID: Int,
        generateEventID: () -> Int = { Int.random(in: 1000...9999) } //for now, random int generation for the id
    ) -> Event {
        let calendar = Calendar.current
        let mergedStart = Date.merge(date: selectedDate, time: startTime)
        let mergedEnd = Date.merge(date: selectedDate, time: endTime)
        
        if var updatedEvent = originalEvent {
            // Updating an existing event.
            updatedEvent.title = title
            updatedEvent.description = description
            updatedEvent.startTimestamp = Int(mergedStart.timestamp)
            updatedEvent.endTimestamp = Int(mergedEnd.timestamp)
            updatedEvent.date = calendar.startOfDay(for: selectedDate)
            updatedEvent.memberIDs = Array(selectedMemberIDs)
            // plannerID and id should remain unchanged.
            return updatedEvent
        } else {
            // creating a new event
            return Event(
                date: calendar.startOfDay(for: selectedDate),
                description: description,
                endTimestamp: Int(mergedEnd.timestamp),
                id: generateEventID(),
                plannerID: plannerID,
                memberIDs: Array(selectedMemberIDs),
                title: title,
                startTimestamp: Int(mergedStart.timestamp)
            )
        }
    }
}
