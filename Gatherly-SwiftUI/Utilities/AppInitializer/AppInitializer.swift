//
//  AppInitializer.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 5/22/25.
//

import Foundation

struct AppInitializer {
    static func runIfNeeded() {
        if ProcessInfo.processInfo.environment["UITESTING"] == "1" {
            UserDefaultsManager.resetAll()
            applySampleData()
        } else if !UserDefaultsManager.getDidSeedSampleData() {
            applySampleData()
        }
    }
    
    private static func applySampleData() {
        var users = SampleData.sampleUsers
        let events = SampleData.sampleEvents
        let groups = SampleData.sampleGroups
                
        if let currentUserIndex = users.firstIndex(where: { $0.id == SampleData.currentUserID }) {
            var currentUser = users[currentUserIndex]
            
            currentUser.groupIDs = groups
                .filter { $0.leaderID == SampleData.currentUserID || $0.memberIDs.contains(SampleData.currentUserID) }
                .compactMap { $0.id }
            
            currentUser.friendIDs = [2, 3, 4]
            users[currentUserIndex] = currentUser
        }
        
        let usersDict  = users.keyedBy(\.id)
        let eventsDict = events.keyedBy(\.id)
        let groupsDict = groups.keyedBy(\.id)
        
        UserDefaultsManager.saveUsers(usersDict)
        if let currentUser = usersDict[SampleData.currentUserID] {
            UserDefaultsManager.saveCurrentUser(currentUser)
        }
        UserDefaultsManager.saveEvents(eventsDict)
        UserDefaultsManager.saveGroups(groupsDict)
        UserDefaultsManager.setDidSeedSampleData(true)
    }
}
