//
//  Event.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/4/25.
//

import Foundation

struct Event: Codable, Equatable, Identifiable {
    var bannerImageName: String?
    var categories: [EventCategory] = []
    var date: Date?
    var description: String?
    var endTimestamp: Int?
    var id: Int?
    var plannerID: Int?
    var location: Location?
    var memberIDs: [Int]?
    var messages: [Message]?
    var title: String?
    var startTimestamp: Int?
    
    // MARK: - Computed Vars
    
    var hasStarted: Bool {
        guard let startTimestamp else {
            return false
        }
        
        let currentTimestamp = Int(Date().timestamp)
        return startTimestamp < currentTimestamp
    }
    
    var hasEnded: Bool {
        guard let endTimestamp else {
            return false
        }
        
        let currentTimestamp = Int(Date().timestamp)
        return endTimestamp < currentTimestamp
    }
    
    var isOngoing: Bool {
        return hasStarted && !hasEnded
    }
    
    // MARK: - Sort
    
    var sortKey: (Date, Int) {
        let day = date ?? .distantFuture
        let start = startTimestamp ?? 0
        return (day, start)
    }
}
