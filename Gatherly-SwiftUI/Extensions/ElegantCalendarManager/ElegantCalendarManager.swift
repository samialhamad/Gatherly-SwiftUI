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
        let config = CalendarConfiguration(startDate: Date().addingTimeInterval(-60*60*24*365),
                                           endDate: Date().addingTimeInterval(60*60*24*365))
        
        let manager = ElegantCalendarManager(configuration: config,
                                             initialMonth: selectedDate.wrappedValue)
        
        manager.delegate = EventHighlightDelegate(selectedDate: selectedDate, events: events)
        return manager
    }
}
