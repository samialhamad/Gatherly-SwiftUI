//
//  UpdateUserTests.swift
//  Gatherly-SwiftUITests
//
//  Created by Sami Alhamad on 5/8/25.
//

import Combine
import XCTest
@testable import Gatherly_SwiftUI

final class UpdateUserTests: XCTestCase {
    
    var cancellables = Set<AnyCancellable>()
    
    override func setUp() {
        super.setUp()
        UserDefaultsManager.removeUsers()
    }
    
    func makeSampleUser(id: Int = 1) -> User {
        User(
            createdTimestamp: Int(Date().timestamp),
            email: nil,
            eventIDs: [],
            firstName: "Old",
            friendIDs: [],
            groupIDs: [],
            id: id,
            isEmailEnabled: false,
            lastName: "Name",
            phone: nil
        )
    }
    
    func testUpdateUser_updatesNameCorrectly() {
        let expectation = XCTestExpectation(description: "User name is updated")
        
        var originalUser = makeSampleUser(id: 1)
        UserDefaultsManager.saveUsers([originalUser])
        
        originalUser.firstName = "New"
        originalUser.lastName = "User"
        
        GatherlyAPI.updateUser(originalUser)
            .sink { updatedUser in
                XCTAssertEqual(updatedUser.firstName, "New")
                XCTAssertEqual(updatedUser.lastName, "User")
                
                let storedUsers = UserDefaultsManager.loadUsers()
                XCTAssertEqual(storedUsers.count, 1)
                XCTAssertEqual(storedUsers.first?.firstName, "New")
                XCTAssertEqual(storedUsers.first?.lastName, "User")
                
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 3)
    }
    
    func testUpdateUser_updatesAvatarAndBanner() {
        let expectation = XCTestExpectation(description: "User avatar and banner are updated")
        
        var originalUser = makeSampleUser(id: 1)
        UserDefaultsManager.saveUsers([originalUser])
        
        originalUser.avatarImageName = "avatar123.png"
        originalUser.bannerImageName = "banner123.png"
        
        GatherlyAPI.updateUser(originalUser)
            .sink { updatedUser in
                XCTAssertEqual(updatedUser.avatarImageName, "avatar123.png")
                XCTAssertEqual(updatedUser.bannerImageName, "banner123.png")
                
                let storedUser = UserDefaultsManager.loadUsers().first
                XCTAssertEqual(storedUser?.avatarImageName, "avatar123.png")
                XCTAssertEqual(storedUser?.bannerImageName, "banner123.png")
                
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 3)
    }
}
