//
//  SampleData.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/4/25.
//

import Foundation

struct SampleData {
    static let sampleEvents: [Event] = [
        Event(
            date: Calendar.current.date(byAdding: .day, value: 1, to: Date()),
            endTimestamp: Int(Date().addingTimeInterval(90000).timeIntervalSince1970),
            id: 1,
            title: "Event Tomorrow",
            startTimestamp: Int(Date().addingTimeInterval(86400).timeIntervalSince1970)
        ),
        Event(
            date: Calendar.current.date(byAdding: .day, value: 7, to: Date()),
            endTimestamp: Int(Date().addingTimeInterval((7 * 86400) + 3600).timeIntervalSince1970),
            id: 2,
            title: "Event in One Week",
            startTimestamp: Int(Date().addingTimeInterval(7 * 86400).timeIntervalSince1970)
        ),
        Event(
            date: Calendar.current.date(byAdding: .day, value: 30, to: Date()),
            endTimestamp: Int(Date().addingTimeInterval((30 * 86400) + 7200).timeIntervalSince1970),
            id: 3,
            title: "Event in One Month",
            startTimestamp: Int(Date().addingTimeInterval(30 * 86400).timeIntervalSince1970)
        )
    ]
}

