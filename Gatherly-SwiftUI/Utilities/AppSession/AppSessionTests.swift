//
//  AppSessionTests.swift
//  Gatherly-SwiftUITests
//
//  Created by Sami Alhamad on 5/13/25.
//

import XCTest
@testable import Gatherly_SwiftUI

final class AppSessionTests: XCTestCase {
    
    func testLoadAllData_seedsSampleDataOnFirstLaunch() {
        let session = AppSession()
        
        UserDefaults.standard.removeObject(forKey: "didSeedSampleData")
        UserDefaultsManager.resetAll()
        
        session.loadAllData()
        
        XCTAssertFalse(session.friendsDict.isEmpty)
        XCTAssertEqual(session.currentUser?.id, 1)
    }
    
    func testSaveAllData_persistsToUserDefaults() {
        let session = AppSession()
        session.users = SampleData.sampleUsers
        session.events = SampleData.sampleEvents
        session.groups = SampleData.sampleGroups
        
        session.saveAllData()
        
        let savedUsers = UserDefaultsManager.loadUsers()
        
        XCTAssertEqual(savedUsers.count, SampleData.sampleUsers.count)
    }
    
    func testAppendUsersAndUpdateFriends() {
        let session = AppSession()
        let currentUser = User(firstName: "Sami", friendIDs: [2], id: 1)
        let existingFriend = User(firstName: "Friend", id: 2)
        session.friendsDict = [1: currentUser, 2: existingFriend]
        session.currentUser = currentUser
        
        let newUsers = [
            User(firstName: "Matt", id: 3),
            User(firstName: "Sara", id: 4)
        ]
        let newFriendIDs = [3, 4]
        
        session.appendUsersAndUpdateFriends(
            newUsers: newUsers,
            newFriendIDs: newFriendIDs,
            currentUserID: 1
        )
        
        guard let updatedCurrentUser = session.friendsDict[1] else {
            XCTFail("Current user not found")
            return
        }
        
        XCTAssertEqual(session.friendsDict.count, 4)
        XCTAssertEqual(Set(updatedCurrentUser.friendIDs ?? []), Set([2, 3, 4]))
    }
}
