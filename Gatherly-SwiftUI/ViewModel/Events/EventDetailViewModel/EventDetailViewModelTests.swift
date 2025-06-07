//
//  EventDetailViewModelTests.swift
//  Gatherly-SwiftUITests
//
//  Created by Sami Alhamad on 6/7/25.
//

import XCTest
@testable import Gatherly_SwiftUI

final class EventDetailViewModelTests: XCTestCase {
    
    var viewModel: EventDetailViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = EventDetailViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testPlannerReturnsCurrentUser_whenPlannerIDMatches() {
        let currentUser = User(id: 1)
        let event = Event(plannerID: 1, memberIDs: [])
        let planner = viewModel.planner(for: event, currentUser: currentUser, friendsDict: [:])
        
        XCTAssertEqual(planner, currentUser)
    }
    
    func testPlannerReturnsFriend_whenPlannerIsNotCurrentUser() {
        let currentUser = User(id: 1)
        let friend = User(id: 2)
        let event = Event(id: 1, plannerID: 2, memberIDs: [1])
        let planner = viewModel.planner(for: event, currentUser: currentUser, friendsDict: [2: friend])
        
        XCTAssertEqual(planner, friend)
    }
    
    func testMembersReturnsEmpty_whenMemberIDsNil() {
        let currentUser = User(id: 1)
        let friend = User(id: 2)
        let event = Event(id: 1, plannerID: 1, memberIDs: nil)
        let members = viewModel.members(for: event, currentUser: currentUser, friendsDict: [2: friend])
        
        XCTAssertTrue(members.isEmpty)
    }
    
    func testMembersExcludesPlannerID() {
        let currentUser = User(id: 1)
        let friend2 = User(id: 2)
        let friend3 = User(id: 3)

        let event = Event(id: 1, plannerID: 1, memberIDs: [1, 2, 3])
        let members = viewModel.members(for: event, currentUser: currentUser, friendsDict: [2: friend2, 3: friend3])
        
        XCTAssertFalse(members.contains(where: { $0.id == 1 }))
        XCTAssertEqual(members, [friend2, friend3])
    }
    
    func testMembersMapsCurrentUserAndFriends() {
        let currentUser = User(id: 1)
        let friend = User(id: 2)
        let event = Event(id: 1, plannerID: 0, memberIDs: [1, 2])
        let members = viewModel.members(for: event, currentUser: currentUser, friendsDict: [2: friend])
        
        XCTAssertEqual(members, [currentUser, friend])
    }
}
