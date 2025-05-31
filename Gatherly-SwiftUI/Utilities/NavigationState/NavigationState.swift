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
    
    func pushToEventDetail(_ event: Event) {
        switchToTab(.calendar)
        
        // Clear state to trigger re-navigation
        navigateToEvent = nil
        navigateToEventsForDate = nil
        
        // Schedule in order
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.navigateToEventsForDate = event.date
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.navigateToEvent = event
            }
        }
    }
    
    func switchToTab(_ tab: Tab) {
        selectedTab = tab.rawValue
    }
}
