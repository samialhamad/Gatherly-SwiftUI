//
//  SampleData.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/4/25.
//

import Foundation

struct SampleData {
    static let sampleEvents: [Event] = [
        Event(description: "A gathering for Swift developers",
              endTimestamp: Int(Date().timeIntervalSince1970) + 7200,
              id: 1,
              leaderID: 101,
              memberIDs: [101, 102, 103],
              title: "Swift Meetup",
              startTimestamp: Int(Date().timeIntervalSince1970) + 3600),
        
        Event(description: "Team lunch at a cafe",
              endTimestamp: Int(Date().timeIntervalSince1970) - 3600,
              id: 2,
              leaderID: 102,
              memberIDs: [102, 105, 106],
              title: "Lunch with Team",
              startTimestamp: Int(Date().timeIntervalSince1970) - 7200),
        
        Event(description: "Evening workout at the gym",
              endTimestamp: Int(Date().timeIntervalSince1970) + 21600, id: 3,
              leaderID: 103,
              memberIDs: [103, 107],
              title: "Workout Session",
              startTimestamp: Int(Date().timeIntervalSince1970) + 18000)
    ]
}
