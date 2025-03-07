//
//  NavigationState.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/7/25.
//

import Foundation
import SwiftUI

class NavigationState: ObservableObject {
    @Published var selectedTab: Int = 0
    @Published var calendarSelectedDate: Date = Date()
    @Published var navigateToEvent: Event? = nil
}
