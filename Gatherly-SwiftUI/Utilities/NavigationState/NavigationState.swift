//
//  NavigationState.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/7/25.
//

import Foundation
import SwiftUI

class NavigationState: ObservableObject {
    @Published var calendarSelectedDate: Date = Date()
    @Published var hasShownDayEventsView = false
    @Published var navigateToEvent: Event? = nil
    @Published var navigateToEventsForDate: Date? = nil
    @Published var navigateToGroup: UserGroup? = nil
    @Published var selectedTab: Int = 0
}
