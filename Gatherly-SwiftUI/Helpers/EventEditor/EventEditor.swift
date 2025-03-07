//
//  EventEditor.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/6/25.
//

import Foundation
import SwiftUI

struct EventEditor {
    static func createEvent(
        title: String,
        description: String,
        selectedDate: Date,
        startTime: Date,
        endTime: Date,
        selectedMemberIDs: Set<Int>,
        plannerID: Int,
        generateEventID: () -> Int = { Int.random(in: 1000...9999) } // this has to change in future, for now just assign a random int id
    ) -> Event {
        let calendar = Calendar.current
        let mergedStart = DateUtils.merge(date: selectedDate, time: startTime)
        let mergedEnd = DateUtils.merge(date: selectedDate, time: endTime)
        
        return Event(
            date: calendar.startOfDay(for: selectedDate),
            description: description,
            endTimestamp: Int(mergedEnd.timeIntervalSince1970),
            id: generateEventID(),
            plannerID: plannerID,
            memberIDs: Array(selectedMemberIDs),
            title: title,
            startTimestamp: Int(mergedStart.timeIntervalSince1970)
        )
    }
    
    static func updateEvent(
        originalEvent: Event,
        title: String,
        description: String,
        selectedDate: Date,
        startTime: Date,
        endTime: Date,
        selectedMemberIDs: Set<Int>
    ) -> Event {
        var updatedEvent = originalEvent
        let calendar = Calendar.current
        let mergedStart = DateUtils.merge(date: selectedDate, time: startTime)
        let mergedEnd = DateUtils.merge(date: selectedDate, time: endTime)
        
        updatedEvent.title = title
        updatedEvent.description = description
        updatedEvent.startTimestamp = Int(mergedStart.timeIntervalSince1970)
        updatedEvent.endTimestamp = Int(mergedEnd.timeIntervalSince1970)
        updatedEvent.date = calendar.startOfDay(for: selectedDate)
        updatedEvent.memberIDs = Array(selectedMemberIDs)
        return updatedEvent
    }
}

