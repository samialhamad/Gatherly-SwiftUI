//
//  EventHighlightDelegate.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 5/6/25.
//

import Foundation
import ElegantCalendar
import SwiftUI

final class EventHighlightDelegate: ElegantCalendarDelegate {
    @Binding var selectedDate: Date
    let events: [Event]
    
    init(selectedDate: Binding<Date>, events: [Event]) {
        _selectedDate = selectedDate
        self.events = events
    }
    
    func calendar(didSelectDay date: Date) {
        selectedDate = date
    }
    
    func backgroundColor(for date: Date) -> Color {
        if Calendar.current.isDate(date, inSameDayAs: selectedDate) {
            return Color(Colors.primary)
        } else if hasEvent(on: date) {
            return Color(Colors.primary).opacity(0.2)
        } else {
            return .clear
        }
    }
    
    func textColor(for date: Date) -> Color {
        hasEvent(on: date) ? .primary : .secondary
    }
    
    func didTapDay(date: Date) {
        selectedDate = date
    }
    
    private func hasEvent(on date: Date) -> Bool {
        events.contains { event in
            if let eventDate = event.date {
                return Calendar.current.isDate(eventDate, inSameDayAs: date)
            }
            return false
        }
    }
}
