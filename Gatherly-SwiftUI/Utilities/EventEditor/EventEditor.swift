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
        event.memberIDs = Array(selectedMemberIDs)
        
        return event
    }
}

extension EventEditor {
    static func isFormEmpty(title: String, description: String) -> Bool {
        title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
        description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
