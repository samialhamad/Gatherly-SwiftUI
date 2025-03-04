//
//  UserTests.swift
//  Gatherly-SwiftUITests
//
//  Created by Sami Alhamad on 3/4/25.
//

import XCTest
@testable import Gatherly_SwiftUI

final class UserTests: XCTestCase {

    //MARK: - Equatable
    
    func testEqualTrue() {
            let user0 = User(firstName: "Sami", id: 0)
            let user1 = User(firstName: "Sami", id: 0)

            XCTAssertEqual(user0, user1)
    }
    
    func testEqualFalse() {
            let user0 = User(firstName: "Sami", id: 0)
            let user1 = User(firstName: "Matt", id: 1)

            XCTAssertNotEqual(user0, user1)
    }

    //MARK: - Computed Vars

    func testUserHasFriendsTrue() {
        let user0 = User(firstName: "Sami", friendIDs: [1], id: 0)
        XCTAssertTrue(user0.hasFriends)
    }
    
    func testUserHasFriendsFalse() {
        let user0 = User(firstName: "Sami", friendIDs: [], id: 0)
        XCTAssertFalse(user0.hasFriends)
    }
    
    func testUserHasFriendsNil() {
        let user0 = User(firstName: "Sami", id: 0)
        XCTAssertFalse(user0.hasFriends)
    }
    
    func testUserHasEventsTrue() {
        let user0 = User(eventIDs: [1], firstName: "Sami", id: 0)
        XCTAssertTrue(user0.hasEvents)
    }
    
    func testUserHasEventsFalse() {
        let user0 = User(eventIDs: [], firstName: "Sami", id: 0)
        XCTAssertFalse(user0.hasEvents)
    }
    
    func testUserHasEventsNil() {
        let user0 = User(firstName: "Sami", id: 0)
        XCTAssertFalse(user0.hasEvents)
    }
    
}
