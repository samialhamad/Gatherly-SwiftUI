//
//  DayEventsViewModel.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 6/7/25.
//

import SwiftUI

struct DayEventsViewModel {
    
    static func allEvents(for events: [Event], on date: Date) -> [Event] {
        events.filter { event in
            guard let eventDate = event.date else {
                return false
            }
            
            return Date.isSameDay(date1: eventDate, date2: date)
        }
    }
    
    static func finishedEvents(for events: [Event], on date: Date) -> [Event] {
        allEvents(for: events, on: date)
            .filter(\.hasEnded)
    }
    
    static func onGoingEvents(for events: [Event], on date: Date) -> [Event] {
        allEvents(for: events, on: date)
            .filter(\.isOngoing)
    }
    
    static func upcomingEvents(for events: [Event], on date: Date) -> [Event] {
        allEvents(for: events, on: date)
            .filter { !$0.hasStarted && !$0.hasEnded }
    }
}
