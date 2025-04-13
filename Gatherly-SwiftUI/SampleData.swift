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
            createdTimestamp: Int(Date().timestamp),
            deviceToken: "abc123",
            email: "sami@example.com",
            eventIDs: nil,
            firstName: "Sami",
            friendIDs: [2, 3, 4, 5, 6, 7, 8, 9],
            groupIDs: [1, 2],
            id: 1,
            isEmailEnabled: true,
            lastName: "Alhamad",
            phone: "1234567890"
        ),
        User(
            createdTimestamp: Int(Date().timestamp),
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
            createdTimestamp: Int(Date().timestamp),
            deviceToken: "ghi789",
            email: "charlie@example.com",
            eventIDs: nil,
            firstName: "Charlie",
            friendIDs: nil,
            id: 3,
            isEmailEnabled: true,
            lastName: "Brown",
            phone: "5555555555"
        ),
        User(
            createdTimestamp: Int(Date().timestamp),
            deviceToken: "def456",
            email: "bob@example.com",
            eventIDs: nil,
            firstName: "Logan",
            friendIDs: nil,
            id: 4,
            isEmailEnabled: true,
            lastName: "Harrison",
            phone: "9876543210"
        ),
        User(
            createdTimestamp: Int(Date().timestamp),
            deviceToken: "def456",
            email: "bob@example.com",
            eventIDs: nil,
            firstName: "Avinav",
            friendIDs: nil,
            id: 5,
            isEmailEnabled: true,
            lastName: "Baral",
            phone: "9876543210"
        ),
        User(
            createdTimestamp: Int(Date().timestamp),
            deviceToken: "def456",
            email: "bob@example.com",
            eventIDs: nil,
            firstName: "Jaiveer",
            friendIDs: nil,
            id: 6,
            isEmailEnabled: true,
            lastName: "Dhaliwhal",
            phone: "9876543210"
        ),
        User(
            createdTimestamp: Int(Date().timestamp),
            deviceToken: "fxc96",
            email: "bob@example.com",
            eventIDs: nil,
            firstName: "Matt",
            friendIDs: nil,
            id: 7,
            isEmailEnabled: true,
            lastName: "Simon",
            phone: "9876543210"
        ),
        User(
            createdTimestamp: Int(Date().timestamp),
            deviceToken: "fxc96",
            email: "bob@example.com",
            eventIDs: nil,
            firstName: "Ali",
            friendIDs: nil,
            id: 8,
            isEmailEnabled: true,
            lastName: "Hamed",
            phone: "9876543210"
        ),
        User(
            createdTimestamp: Int(Date().timestamp),
            deviceToken: "fxc96",
            email: "bob@example.com",
            eventIDs: nil,
            firstName: "Zebra",
            friendIDs: nil,
            id: 9,
            isEmailEnabled: true,
            lastName: "Zebrus",
            phone: "9876543210"
        ),
        User(
            createdTimestamp: Int(Date().timestamp),
            deviceToken: "45596",
            email: "woah@zowers.com",
            eventIDs: nil,
            firstName: "LeBron",
            friendIDs: nil,
            id: 10,
            isEmailEnabled: true,
            lastName: "James",
            phone: "122872722"
        ),
        User(
            createdTimestamp: Int(Date().timestamp),
            deviceToken: "mj232",
            email: "mj@nike.com",
            eventIDs: nil,
            firstName: "Michael",
            friendIDs: nil,
            id: 11,
            isEmailEnabled: true,
            lastName: "Jordan",
            phone: "9876543210"
        )
    ]
    
    static let sampleEvents: [Event] = [
        Event(
            categories: randomCategories(),
            date: Calendar.current.date(byAdding: .day, value: -30, to: Date()),
            description: "Event from the past",
            endTimestamp: Int(Date().addingTimeInterval((-30 * 86400) + 7200).timestamp),
            id: 0,
            plannerID: 1,
            location: Location(latitude: 37.7749, longitude: -122.4194, name: "San Francisco"),
            memberIDs: [2],
            title: "Event from whenever in the past",
            startTimestamp: Int(Date().addingTimeInterval(-30 * 86400).timestamp)
        ),
        Event(
            categories: randomCategories(),
            date: Calendar.current.date(byAdding: .day, value: -1, to: Date()),
            description: "Event from yesterday",
            endTimestamp: Int(Date().addingTimeInterval(-3600).timestamp),
            id: 1,
            plannerID: 1,
            location: Location(latitude: 37.7749, longitude: -122.4194, name: "San Francisco"),
            memberIDs: [2, 3],
            title: "Event Yesterday",
            startTimestamp: Int(Date().addingTimeInterval(-7200).timestamp)
        ),
        Event(
            categories: randomCategories(),
            date: Date(),
            description: "Event 1 for today, finished, test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test",
            endTimestamp: Int(Date().addingTimeInterval(-3600).timestamp),
            id: 2,
            plannerID: 1,
            location: Location(latitude: 34.0522, longitude: -118.2437, name: "Los Angeles"),
            memberIDs: [2, 3],
            title: "Event 1 Today",
            startTimestamp: Int(Date().addingTimeInterval(-7200).timestamp)
        ),
        Event(
            categories: randomCategories(),
            date: Date(),
            description: "Event 2 for today, ongoing",
            endTimestamp: Int(Date().addingTimeInterval(3600).timestamp),
            id: 3,
            plannerID: 1,
            location: Location(latitude: 40.7128, longitude: -74.0060, name: "New York"),
            memberIDs: [2, 3],
            title: "Event 2 Today",
            startTimestamp: Int(Date().addingTimeInterval(-3600).timestamp)
        ),
        Event(
            categories: randomCategories(),
            date: Date(),
            description: "Event 3 for today, in an hour",
            endTimestamp: Int(Date().addingTimeInterval(7200).timestamp),
            id: 4,
            plannerID: 1,
            location: Location(latitude: 51.5074, longitude: -0.1278, name: "London"),
            memberIDs: [2, 3],
            title: "Event 3 Today",
            startTimestamp: Int(Date().addingTimeInterval(3600).timestamp)
        ),
        Event(
            categories: randomCategories(),
            date: Date(),
            description: "Event 4 for today, in an hour",
            endTimestamp: Int(Date().addingTimeInterval(7200).timestamp),
            id: 5,
            plannerID: 1,
            location: Location(latitude: 51.5074, longitude: -0.1278, name: "London"),
            memberIDs: [2, 3],
            title: "Event 4 Today",
            startTimestamp: Int(Date().addingTimeInterval(3600).timestamp)
        ),
        Event(
            categories: randomCategories(),
            date: Date(),
            description: "Event 5 for today, in an hour",
            endTimestamp: Int(Date().addingTimeInterval(7200).timestamp),
            id: 6,
            plannerID: 1,
            location: Location(latitude: 51.5074, longitude: -0.1278, name: "London"),
            memberIDs: [2, 3],
            title: "Event 5 Today",
            startTimestamp: Int(Date().addingTimeInterval(3600).timestamp)
        ),
        Event(
            categories: randomCategories(),
            date: Date(),
            description: "Event 6 for today, in an hour",
            endTimestamp: Int(Date().addingTimeInterval(7200).timestamp),
            id: 7,
            plannerID: 1,
            location: Location(latitude: 51.5074, longitude: -0.1278, name: "London"),
            memberIDs: [2, 3],
            title: "Event 6 Today",
            startTimestamp: Int(Date().addingTimeInterval(3600).timestamp)
        ),
        Event(
            categories: randomCategories(),
            date: Date(),
            description: "Event 7 for today, in an hour",
            endTimestamp: Int(Date().addingTimeInterval(7200).timestamp),
            id: 8,
            plannerID: 1,
            location: Location(latitude: 51.5074, longitude: -0.1278, name: "London"),
            memberIDs: [2, 3],
            title: "Event 7 Today",
            startTimestamp: Int(Date().addingTimeInterval(3600).timestamp)
        ),
        Event(
            categories: randomCategories(),
            date: Date(),
            description: "Event 8 for today, in an hour",
            endTimestamp: Int(Date().addingTimeInterval(7200).timestamp),
            id: 9,
            plannerID: 1,
            location: Location(latitude: 51.5074, longitude: -0.1278, name: "London"),
            memberIDs: [2, 3],
            title: "Event 8 Today",
            startTimestamp: Int(Date().addingTimeInterval(3600).timestamp)
        ),
        Event(
            categories: randomCategories(),
            date: Calendar.current.date(byAdding: .day, value: 1, to: Date()),
            description: "Event planned for tomorrow, hope to see you there!",
            endTimestamp: Int(Date().addingTimeInterval(90000).timestamp),
            id: 10,
            plannerID: 2,
            location: Location(latitude: 48.8566, longitude: 2.3522, name: "Paris"),
            memberIDs: [1, 3],
            title: "Event Tomorrow",
            startTimestamp: Int(Date().addingTimeInterval(86400).timestamp)
        ),
        Event(
            categories: randomCategories(),
            date: Calendar.current.date(byAdding: .day, value: 7, to: Date()),
            description: "Event planned for next week, hope to see you there!",
            endTimestamp: Int(Date().addingTimeInterval((7 * 86400) + 3600).timestamp),
            id: 11,
            plannerID: 3,
            location: Location(latitude: 35.6895, longitude: 139.6917, name: "Tokyo"),
            memberIDs: [1, 2],
            title: "Event in One Week",
            startTimestamp: Int(Date().addingTimeInterval(7 * 86400).timestamp)
        ),
        Event(
            categories: randomCategories(),
            date: Calendar.current.date(byAdding: .day, value: 30, to: Date()),
            description: "Event planned for a month from today, hope to see you there!",
            endTimestamp: Int(Date().addingTimeInterval((30 * 86400) + 7200).timestamp),
            id: 12,
            plannerID: 1,
            location: Location(latitude: 52.5200, longitude: 13.4050, name: "Berlin"),
            memberIDs: [2, 3],
            title: "Event in One Month",
            startTimestamp: Int(Date().addingTimeInterval(30 * 86400).timestamp)
        )
    ]
    
    static let sampleGroups: [UserGroup] = [
        UserGroup(
            id: 1,
            name: "Group Sami Leads",
            memberIDs: [2, 3],
            leaderID: 1,
            messages: [
                Message(id: 1, userID: 1, message: "Welcome to the group!", read: true)
            ]
        ),
        UserGroup(
            id: 2,
            name: "Group I'm a Member in",
            memberIDs: [1, 5],
            leaderID: 4,
            messages: [
                Message(id: 2, userID: 4, message: "Let's plan an event!", read: false)
            ]
        ),
        UserGroup(
            id: 3,
            name: "Group Sami is not in",
            memberIDs: [4, 5, 6],
            leaderID: 4,
            messages: [
                Message(id: 1, userID: 4, message: "Welcome to the group!", read: true)
            ]
        )
    ]
}

private func randomCategories() -> [EventCategory] {
    let allCategories = EventCategory.allCases
    let randomCount = Int.random(in: 0...3) // Each event gets 1-3 random categories
    return Array(allCategories.shuffled().prefix(randomCount))
}
