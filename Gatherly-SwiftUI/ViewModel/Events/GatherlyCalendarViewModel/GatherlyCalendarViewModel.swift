//
//  GatherlyCalendarViewModel.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 6/4/25.
//

import Foundation
import SwiftUI

class GatherlyCalendarViewModel: ObservableObject {
    
    func eventCountLabel(for date: Date, events: [Event]) -> String {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let selectedDay = calendar.startOfDay(for: date)
        
        let count = events.filter {
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
            return count == 0 ? "No plans on \(selectedDay.formatted(.dateTime.month(.wide).day()))!"
            : count == 1 ? "1 upcoming event on \(selectedDay.formatted(.dateTime.month(.wide).day()))!"
            : "\(count) upcoming events on \(selectedDay.formatted(.dateTime.month(.wide).day()))!"
        }
    }
}
