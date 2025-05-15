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
    
    let session: AppSession
    
    init(selectedDate: Binding<Date>, session: AppSession) {
        _selectedDate = selectedDate
        self.session = session
    }
    
    func calendar(didSelectDay date: Date) {
        selectedDate = date
        
        if session.navigationState.hasShownDayEventsView == false {
            session.navigationState.hasShownDayEventsView = true
            return
        }
        
        let hasEvents = session.events.contains { event in
            guard let eventDate = event.date else {
                return false
            }
            
            return Date.isSameDay(date1: eventDate, date2: date)
        }
        
        if hasEvents {
            session.navigationState.navigateToEventsForDate = date
        }
    }
    
    func backgroundColor(for date: Date) -> Color {
        if Date.isSameDay(date1: date, date2: selectedDate) {
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
    
    private func hasEvent(on date: Date) -> Bool {
        session.events.contains { event in
            if let eventDate = event.date {
                return Date.isSameDay(date1: eventDate, date2: date)
            }
            
            return false
        }
    }
}
