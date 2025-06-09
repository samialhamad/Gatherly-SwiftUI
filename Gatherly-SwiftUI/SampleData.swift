//
//  SampleData.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/4/25.
//

import Foundation

struct SampleData {
    
    static let currentUserID: Int = 1
    
    static let sampleUsers: [User] = [
        User(
            createdTimestamp: Int(Date().timestamp),
            eventIDs: nil,
            firstName: "Sami",
            friendIDs: [2, 3, 4],
            groupIDs: [1, 2],
            id: 1,
            lastName: "Alhamad",
            phone: "1234567890"
        ),
        User(
            createdTimestamp: Int(Date().timestamp),
            eventIDs: nil,
            firstName: "Bob",
            friendIDs: nil,
            id: 2,
            lastName: "Jones",
            phone: "9876543210"
        ),
        User(
            createdTimestamp: Int(Date().timestamp),
            eventIDs: nil,
            firstName: "Charlie",
            friendIDs: nil,
            id: 3,
            lastName: "Brown",
            phone: "5555555555"
        ),
        User(
            createdTimestamp: Int(Date().timestamp),
            eventIDs: nil,
            firstName: "Zebra",
            friendIDs: nil,
            id: 4,
            lastName: "Zebrus",
            phone: "9876543210"
        )
    ]
    
    static let sampleEvents: [Event] = [
        Event(
            categories: randomCategories(),
            description: "Event from yesterday",
            endTimestamp: Int((Date().minus(calendarComponent: .hour, value: 22) ?? Date()).timestamp),
            id: 1,
            plannerID: 1,
            location: Location(latitude: 37.7749, longitude: -122.4194, name: "San Francisco"),
            memberIDs: [2, 3],
            title: "Event Yesterday",
            startTimestamp: Int((Date().minus(calendarComponent: .hour, value: 24) ?? Date()).timestamp)
        ),
        Event(
            categories: randomCategories(),
            description: "Event 1 for today, finished, test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test",
            endTimestamp: Int((Date().minus(calendarComponent: .hour, value: 1) ?? Date()).timestamp),
            id: 2,
            plannerID: 1,
            location: Location(latitude: 34.0522, longitude: -118.2437, name: "Los Angeles"),
            memberIDs: [2, 3],
            title: "Event 1 Today",
            startTimestamp: Int((Date().minus(calendarComponent: .hour, value: 2) ?? Date()).timestamp)
        ),
        Event(
            categories: randomCategories(),
            description: "Event 2 for today, ongoing",
            endTimestamp: Int((Date().plus(calendarComponent: .hour, value: 1) ?? Date()).timestamp),
            id: 3,
            plannerID: 1,
            location: Location(latitude: 40.7128, longitude: -74.0060, name: "New York"),
            memberIDs: [2, 3],
            title: "Event 2 Today",
            startTimestamp: Int((Date().minus(calendarComponent: .hour, value: 1) ?? Date()).timestamp)
        ),
        Event(
            categories: randomCategories(),
            description: "Event 3 for today, in an hour",
            endTimestamp: Int((Date().plus(calendarComponent: .hour, value: 2) ?? Date()).timestamp),
            id: 4,
            plannerID: 1,
            location: Location(latitude: 51.5074, longitude: -0.1278, name: "London"),
            memberIDs: [2, 3],
            title: "Event 3 Today",
            startTimestamp: Int((Date().plus(calendarComponent: .hour, value: 1) ?? Date()).timestamp)
        ),
        Event(
            categories: randomCategories(),
            description: "Event planned for tomorrow, hope to see you there!",
            endTimestamp: Int((Date().plus(calendarComponent: .hour, value: 25) ?? Date()).timestamp),
            id: 5,
            plannerID: 2,
            location: Location(latitude: 48.8566, longitude: 2.3522, name: "Paris"),
            memberIDs: [1, 3],
            title: "Event Tomorrow",
            startTimestamp: Int((Date().plus(calendarComponent: .hour, value: 24) ?? Date()).timestamp)
        )
    ]
    
    static let sampleGroups: [UserGroup] = [
        UserGroup(
            id: 1,
            leaderID: 1,
            memberIDs: [2, 3],
            messages: [
                Message(id: 1, userID: 1, message: "Welcome to the group!", read: true)
            ],
            name: "Group Sami Leads"
        ),
        UserGroup(
            id: 2,
            leaderID: 4,
            memberIDs: [1, 5],
            messages: [
                Message(id: 2, userID: 4, message: "Let's plan an event!", read: false)
            ],
            name: "Group I'm a Member in"
        )
    ]
}

private func randomCategories() -> [EventCategory] {
    let allCategories = EventCategory.allCases
    let randomCount = Int.random(in: 0...3) // Each event gets 1-3 random categories
    return Array(allCategories.shuffled().prefix(randomCount))
}
