//
//  AppInitializer.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 5/22/25.
//

import Foundation

enum AppInitializer {
    static func runIfNeeded() {
        if CommandLine.arguments.contains("--uitesting") {
            print("UI Testing: Resetting UserDefaults and loading SampleData")
            UserDefaultsManager.resetAll()
            applySampleData()
        } else if !UserDefaultsManager.getDidSeedSampleData() {
            applySampleData()
        }
    }

    private static func applySampleData() {
        let users = SampleData.sampleUsers
        let events = SampleData.sampleEvents
        let groups = SampleData.sampleGroups

        var updatedUsers = users

        if let samiIndex = updatedUsers.firstIndex(where: { $0.id == 1 }) {
            var sami = updatedUsers[samiIndex]

            sami.eventIDs = events
                .filter { $0.plannerID == 1 || ($0.memberIDs?.contains(1) ?? false) }
                .compactMap { $0.id }

            sami.groupIDs = groups
                .filter { $0.leaderID == 1 || $0.memberIDs.contains(1) }
                .compactMap { $0.id }

            sami.friendIDs = [2, 3, 4]
            updatedUsers[samiIndex] = sami
        }

        UserDefaultsManager.saveUsers(updatedUsers)
        UserDefaultsManager.saveEvents(events)
        UserDefaultsManager.saveGroups(groups)
        UserDefaultsManager.setDidSeedSampleData(true)
    }
}
