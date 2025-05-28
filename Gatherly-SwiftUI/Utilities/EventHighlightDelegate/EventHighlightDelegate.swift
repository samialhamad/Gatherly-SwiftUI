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
    @Binding var events: [Event]
    @Binding var selectedDate: Date
    
    private var didAutoSelectInitialDate = false
    let navigationState: NavigationState
    
    init(
        selectedDate: Binding<Date>,
        events: Binding<[Event]>,
        navigationState: NavigationState
    ) {
        _selectedDate = selectedDate
        _events = events
        self.navigationState = navigationState
    }
    
    func calendar(didSelectDay date: Date) {
        selectedDate = date
        
        // Skip the first automatic call to resolve app launch bug
        if !didAutoSelectInitialDate {
            didAutoSelectInitialDate = true
            return
        }
        
        if !navigationState.hasShownDayEventsView {
            navigationState.hasShownDayEventsView = true
            return
        }
        
        if hasEvent(on: date) {
            navigationState.navigateToEventsForDate = date
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
        events.contains { event in
            if let eventDate = event.date {
                return Date.isSameDay(date1: eventDate, date2: date)
            }
            
            return false
        }
    }
}
