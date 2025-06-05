//
//  GetCurrentUserTests.swift
//  Gatherly-SwiftUITests
//
//  Created by Sami Alhamad on 5/27/25.
//

import Combine
import XCTest
@testable import Gatherly_SwiftUI

final class GetCurrentUserTests: XCTestCase {
    
    var cancellables = Set<AnyCancellable>()
    
    override func setUp() {
        super.setUp()
        UserDefaultsManager.removeCurrentUser()
    }
    
    func testGetCurrentUser() {
        let expectation = XCTestExpectation(description: "Current user is retrieved from UserDefaults")
        
        let testUser = User(
            avatarImageName: "avatar.png",
            bannerImageName: "banner.png",
            eventIDs: [100],
            firstName: "Test",
            friendIDs: [2, 3],
            groupIDs: [10],
            id: 1,
            lastName: "User"
        )
        
        UserDefaultsManager.saveCurrentUser(testUser)
        
        GatherlyAPI.getCurrentUser()
            .sink { user in
                XCTAssertNotNil(user)
                XCTAssertEqual(user?.id, 1)
                XCTAssertEqual(user?.firstName, "Test")
                XCTAssertEqual(user?.lastName, "User")
                XCTAssertEqual(user?.friendIDs, [2, 3])
                XCTAssertEqual(user?.groupIDs, [10])
                XCTAssertEqual(user?.eventIDs, [100])
                XCTAssertEqual(user?.avatarImageName, "avatar.png")
                XCTAssertEqual(user?.bannerImageName, "banner.png")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 3)
    }
    
    func testGetCurrentUser_returnsNilWhenNotSet() {
        let expectation = XCTestExpectation(description: "Returns nil when no current user is stored")
                
        GatherlyAPI.getCurrentUser()
            .sink { user in
                XCTAssertNil(user)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 3)
    }
}
