//
//  Array.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/12/25.
//

import Foundation

// MARK: - Event

extension Array where Element == Event {
    
    func eventCountLabel(for date: Date) -> String {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let selectedDay = calendar.startOfDay(for: date)
        
        let count = self.filter {
            guard let eventDate = $0.date else {
                return false
            }
            return calendar.isDate(eventDate, inSameDayAs: date)
        }.count
        
        switch selectedDay {
        case ..<today:
            return count == 0 ? "Looks like nothing happened this day!"
            : count == 1 ? "1 finished event!"
            : "\(count) finished events!"
            
        case today:
            return count == 0 ? "Nothing planned for today!"
            : count == 1 ? "1 event planned for today!"
            : "\(count) events planned for today!"
            
        default:
            return count == 0 ? "No upcoming plans!"
            : count == 1 ? "1 upcoming event!"
            : "\(count) upcoming events!"
        }
    }
    
    //create a dictionary, grouped by start of day
    var groupEventsByDay: [Date: [Event]] {
        Dictionary(grouping: self, by: { Date.startOfDay($0.date) })
    }
    
    // Returns only events whose date is on the same day as the given date.
    func filterEvents(by day: Date) -> [Event] {
        self.filter { event in
            guard let eventDate = event.date else { return false }
            return Calendar.current.isDate(eventDate, inSameDayAs: day)
        }
    }
}
