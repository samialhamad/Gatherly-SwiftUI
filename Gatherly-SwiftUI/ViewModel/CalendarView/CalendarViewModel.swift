//
//  CalendarViewModel.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/5/25.
//

import Foundation

class CalendarViewModel: ObservableObject {
    func eventCountLabel(for date: Date, events: [Event]) -> String {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let selectedDay = calendar.startOfDay(for: date)
        
        let filteredEvents = events.filter { event in
            guard let eventDate = event.date else { return false }
            return calendar.isDate(eventDate, inSameDayAs: date)
        }
        let count = filteredEvents.count
        
        if selectedDay < today {
            if count == 0 {
                return "No finished events"
            } else if count == 1 {
                return "1 finished event"
            } else {
                return "\(count) finished events"
            }
        }
        
        else if selectedDay == today {
            if count == 0 {
                return "Nothing planned for today!"
            } else if count == 1 {
                return "1 event planned for today"
            } else {
                return "\(count) events planned for today"
            }
        }
        
        else {
            if count == 0 {
                return "No upcoming events"
            } else if count == 1 {
                return "1 upcoming event"
            } else {
                return "\(count) upcoming events"
            }
        }
    }
}

