//
//  NavigationState.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/7/25.
//

import Foundation
import SwiftUI

class NavigationState: ObservableObject {
    @Published var calendarSelectedDate: Date? = Date()
    @Published var navigateToEvent: Event? = nil
    @Published var navigateToEventsForDate: Date? = nil
    @Published var navigateToGroup: UserGroup? = nil
    @Published var selectedTab: Int = Tab.calendar.rawValue
    
    func switchToTab(_ tab: Tab) {
        selectedTab = tab.rawValue
    }
    
    func pushToEventDetailView(_ event: Event) {
        switchToTab(.calendar)
        
        let eventDate = event.date ?? Date()
        
        calendarSelectedDate = eventDate
        navigateToEventsForDate = eventDate
        
        DispatchQueue.main.async {
            self.navigateToEvent = event
        }
    }
}
