//
//  SampleData.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/4/25.
//

import Foundation

struct SampleData {
    static let sampleUsers: [User] = [
        User(
            createdTimestamp: Int(Date().timeIntervalSince1970),
            deviceToken: "abc123",
            email: "alice@example.com",
            eventIDs: nil,
            firstName: "Alice",
            friendIDs: nil,
            id: 1,
            isEmailEnabled: true,
            lastName: "Smith",
            phone: "1234567890"
        ),
        User(
            createdTimestamp: Int(Date().timeIntervalSince1970),
            deviceToken: "def456",
            email: "bob@example.com",
            eventIDs: nil,
            firstName: "Bob",
            friendIDs: nil,
            id: 2,
            isEmailEnabled: true,
            lastName: "Jones",
            phone: "9876543210"
        ),
        User(
            createdTimestamp: Int(Date().timeIntervalSince1970),
            deviceToken: "ghi789",
            email: "charlie@example.com",
            eventIDs: nil,
            firstName: "Charlie",
            friendIDs: nil,
            id: 3,
            isEmailEnabled: true,
            lastName: "Brown",
            phone: "5555555555"
        )
    ]
    
    static let sampleEvents: [Event] = [
        Event(
            date: Calendar.current.date(byAdding: .day, value: -1, to: Date()),
            description: "Event from yesterday",
            endTimestamp: Int(Date().addingTimeInterval(-3600).timestamp),
            id: 1,
            plannerID: 1,
            memberIDs: [2, 3],
            title: "Event Yesterday",
            startTimestamp: Int(Date().addingTimeInterval(-7200).timestamp)
        ),
        Event(
            date: Date(),
            description: "Event 1 for today, finished",
            endTimestamp: Int(Date().addingTimeInterval(-3600).timestamp),
            id: 2,
            plannerID: 1,
            memberIDs: [2, 3],
            title: "Event 1 Today",
            startTimestamp: Int(Date().addingTimeInterval(-7200).timestamp)
        ),
        Event(
            date: Date(),
            description: "Event 2 for today, ongoing",
            endTimestamp: Int(Date().addingTimeInterval(3600).timestamp),
            id: 3,
            plannerID: 1,
            memberIDs: [2, 3],
            title: "Event 2 Today",
            startTimestamp: Int(Date().addingTimeInterval(-3600).timestamp)
        ),
        Event(
            date: Date(),
            description: "Event 3 for today, in an hour",
            endTimestamp: Int(Date().addingTimeInterval(7200).timestamp),
            id: 4,
            plannerID: 1,
            memberIDs: [2, 3],
            title: "Event 3 Today",
            startTimestamp: Int(Date().addingTimeInterval(3600).timestamp)
        ),
        Event(
            date: Calendar.current.date(byAdding: .day, value: 1, to: Date()),
            description: "Event planned for tomorrow, hope to see you there!",
            endTimestamp: Int(Date().addingTimeInterval(90000).timestamp),
            id: 5,
            plannerID: 2,
            memberIDs: [1, 3],
            title: "Event Tomorrow",
            startTimestamp: Int(Date().addingTimeInterval(86400).timestamp)
        ),
        Event(
            date: Calendar.current.date(byAdding: .day, value: 7, to: Date()),
            description: "Event planned for next week, hope to see you there!",
            endTimestamp: Int(Date().addingTimeInterval((7 * 86400) + 3600).timestamp),
            id: 6,
            plannerID: 3,
            memberIDs: [1, 2],
            title: "Event in One Week",
            startTimestamp: Int(Date().addingTimeInterval(7 * 86400).timestamp)
        ),
        Event(
            date: Calendar.current.date(byAdding: .day, value: 30, to: Date()),
            description: "Event planned for a month from today, hope to see you there!",
            endTimestamp: Int(Date().addingTimeInterval((30 * 86400) + 7200).timestamp),
            id: 7,
            plannerID: 1,
            memberIDs: [2, 3],
            title: "Event in One Month",
            startTimestamp: Int(Date().addingTimeInterval(30 * 86400).timestamp)
        )
    ]
}

