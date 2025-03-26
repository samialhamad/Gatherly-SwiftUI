//
//  Event.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/4/25.
//

import Foundation

struct Event: Equatable, Hashable, Identifiable {
    var bannerImageName: String? //for now image name / file path
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
    
    //MARK: - Computed Vars
    
    var hasStarted: Bool {
        guard let eventStartTimestamp = startTimestamp else {
            return false
        }
        
        let currentTimestamp = Int(Date().timestamp)
        return eventStartTimestamp < currentTimestamp
    }

    var hasEnded: Bool {
        guard let eventEndTimestamp = endTimestamp else {
            return false
        }
        
        let currentTimestamp = Int(Date().timestamp)
        return eventEndTimestamp < currentTimestamp
    }
    
    var isOngoing: Bool {
        return hasStarted && !hasEnded
    }
}
