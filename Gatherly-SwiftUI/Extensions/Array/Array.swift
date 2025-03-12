//
//  Array.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/12/25.
//

import Foundation

//MARK: - Event

//create a dictionary, grouped by start of day

extension Array where Element == Event {
    var groupedByDay: [Date: [Event]] {
        Dictionary(grouping: self, by: { Date.startOfDay($0.date) })
    }
}
