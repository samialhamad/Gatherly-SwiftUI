//
//  AppInitializer.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 5/22/25.
//

import Foundation

enum AppInitializer {
    static func runIfNeeded() {
        if ProcessInfo.processInfo.environment["UITESTING"] == "1" {
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
        
        if let samiIndex = updatedUsers.firstIndex(where: { $0.id == Constants.currentUserID }) {
            var sami = updatedUsers[samiIndex]
            
            sami.groupIDs = groups
                .filter { $0.leaderID == Constants.currentUserID || $0.memberIDs.contains(Constants.currentUserID) }
                .compactMap { $0.id }
            
            sami.friendIDs = [2, 3, 4]
            updatedUsers[samiIndex] = sami
        }
        
        let usersDict  = updatedUsers.keyedBy(\.id)
        let eventsDict = events.keyedBy(\.id)
        let groupsDict = groups.keyedBy(\.id)
        
        UserDefaultsManager.saveUsers(usersDict)
        if let current = usersDict[Constants.currentUserID] {
            UserDefaultsManager.saveCurrentUser(current)
        }
        UserDefaultsManager.saveEvents(eventsDict)
        UserDefaultsManager.saveGroups(groupsDict)
        UserDefaultsManager.setDidSeedSampleData(true)
    }
}
