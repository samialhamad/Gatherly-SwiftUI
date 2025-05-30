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
    static func withEvents(events: Binding<[Event]>, navigationState: NavigationState) -> ElegantCalendarManager {
        let now = Date()
        let config = CalendarConfiguration(
            startDate: now.minus(calendarComponent: .day, value: 365) ?? now,
            endDate: now.plus(calendarComponent: .day, value: 365) ?? now
        )
        
        let manager = ElegantCalendarManager(configuration: config, initialMonth: now)
        
        manager.delegate = EventHighlightDelegate(events: events, navigationState: navigationState
        )
        
        return manager
    }
}
