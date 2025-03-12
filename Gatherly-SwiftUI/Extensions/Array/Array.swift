//
//  Array.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/12/25.
//

import Foundation

//MARK: - Event

extension Array where Element == Event {
    
    //create a dictionary, grouped by start of day
    var groupEventsByDay: [Date: [Event]] {
        Dictionary(grouping: self, by: { Date.startOfDay($0.date) })
    }
}
