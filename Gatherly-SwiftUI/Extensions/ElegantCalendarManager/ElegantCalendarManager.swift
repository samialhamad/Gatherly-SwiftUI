//
//  ElegantCalendarManager.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 5/6/25.
//

import ElegantCalendar
import Foundation
import SwiftUI

extension ElegantCalendarManager {
    static func withEvents(selectedDate: Binding<Date>, events: [Event]) -> ElegantCalendarManager {
        let now = Date()
        let config = CalendarConfiguration(
            startDate: now.minus(calendarComponent: .day, value: 365) ?? now,
            endDate: now.plus(calendarComponent: .day, value: 365) ?? now
        )
        
        let manager = ElegantCalendarManager(configuration: config,
                                             initialMonth: selectedDate.wrappedValue)
        
        manager.delegate = EventHighlightDelegate(selectedDate: selectedDate,
                                                  events: events)
        return manager
    }
}
