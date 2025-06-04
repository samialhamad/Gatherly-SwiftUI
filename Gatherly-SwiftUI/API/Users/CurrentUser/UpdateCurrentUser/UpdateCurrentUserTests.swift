//
//  UpdateCurrentUserTests.swift
//  Gatherly-SwiftUITests
//
//  Created by Sami Alhamad on 5/27/25.
//

import Combine
import XCTest
@testable import Gatherly_SwiftUI

final class UpdateCurrentUserTests: XCTestCase {
    
    var cancellables = Set<AnyCancellable>()
    
    override func setUp() {
        super.setUp()
        UserDefaultsManager.removeCurrentUser()
    }
    
    func testUpdateCurrentUserSavesCorrectly() {
        let expectation = XCTestExpectation(description: "Current user is saved to UserDefaults")
        
        let updatedUser = User(
            avatarImageName: "updated_avatar.png",
            bannerImageName: "updated_banner.png",
            email: "updated@example.com",
            eventIDs: [200],
            firstName: "Updated",
            friendIDs: [2, 4],
            groupIDs: [20],
            id: 1,
            lastName: "User"
        )
        
        GatherlyAPI.updateCurrentUser(updatedUser)
            .sink { savedUser in
                XCTAssertEqual(savedUser.id, 1)
                XCTAssertEqual(savedUser.firstName, "Updated")
                XCTAssertEqual(savedUser.lastName, "User")
                XCTAssertEqual(savedUser.email, "updated@example.com")
                XCTAssertEqual(savedUser.friendIDs, [2, 4])
                XCTAssertEqual(savedUser.groupIDs, [20])
                XCTAssertEqual(savedUser.eventIDs, [200])
                XCTAssertEqual(savedUser.avatarImageName, "updated_avatar.png")
                XCTAssertEqual(savedUser.bannerImageName, "updated_banner.png")
                
                let storedUser = UserDefaultsManager.loadCurrentUser()
                XCTAssertNotNil(storedUser)
                XCTAssertEqual(storedUser?.firstName, "Updated")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 3)
    }
}
