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
        session.users = [
            User(firstName: "Sami", friendIDs: [2], id: 1)
        ]
        
        let newUsers = [
            User(firstName: "Matt", id: 3),
            User(firstName: "Sara", id: 4)
        ]
        
        let newFriendIDs = [3, 4]
        
        session.appendUsersAndUpdateFriends(newUsers: newUsers, newFriendIDs: newFriendIDs, currentUserID: 1)
        
        let currentUser = session.users.first(where: { $0.id == 1 })
        
        XCTAssertEqual(session.users.count, 3)
        XCTAssertEqual(Set(currentUser?.friendIDs ?? []), Set([2, 3, 4]))
    }
    
    func testUpdateLocalFriendsAndGroups_setsFriends() {
        let session = AppSession()
        let user1 = User(firstName: "Sami", friendIDs: [2], id: 1)
        let user2 = User(firstName: "Friend", id: 2)
        session.users = [user1, user2]
        session.currentUser = user1

        session.updateLocalFriendsAndGroups()

        XCTAssertEqual(session.friends.count, 1)
        XCTAssertEqual(session.friends.first?.id, 2)
    }
    
    func testGenerateUsersFromContacts() async {
        let session = AppSession()
        session.users = [
            User(firstName: "Sami", id: 1, phone: "1234567890")
        ]
        
        let contacts: [SyncedContact] = [
            SyncedContact(fullName: "Bob Smith", phoneNumber: "9876543210"),
            SyncedContact(fullName: "Alice Jones", phoneNumber: "5556667777"),
            SyncedContact(fullName: "Duplicate", phoneNumber: "1234567890") // should be filtered out
        ]
        
        let (newUsers, newFriendIDs) = await session.generateUsersFromContacts(contacts)

        XCTAssertEqual(newUsers.count, 2)
        XCTAssertEqual(newFriendIDs.count, 2)
        XCTAssertEqual(newUsers[0].firstName, "Bob")
        XCTAssertEqual(newUsers[1].firstName, "Alice")
    }
}
