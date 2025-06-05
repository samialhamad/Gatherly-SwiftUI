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
    
    override func tearDown() {
        UserDefaultsManager.removeUsers()
        super.tearDown()
    }
    
    func makeSampleUser(id: Int = 1) -> User {
        User(
            createdTimestamp: Int(Date().timestamp),
            eventIDs: [],
            firstName: "Old",
            friendIDs: [],
            groupIDs: [],
            id: id,
            lastName: "Name",
            phone: nil
        )
    }
    
    func testUpdateUser_updatesNameCorrectly() {
        let expectation = XCTestExpectation(description: "User name is updated")
        
        var originalUser = makeSampleUser(id: 1)
        
        UserDefaultsManager.saveUsers([originalUser.id!: originalUser])
        
        originalUser.firstName = "New"
        originalUser.lastName = "User"
        
        GatherlyAPI.updateUser(originalUser)
            .sink { updatedUser in
                XCTAssertEqual(updatedUser.firstName, "New")
                XCTAssertEqual(updatedUser.lastName, "User")
                
                let storedDict = UserDefaultsManager.loadUsers()
                XCTAssertEqual(storedDict.count, 1)
                
                if let storedUser = storedDict[1] {
                    XCTAssertEqual(storedUser.firstName, "New")
                    XCTAssertEqual(storedUser.lastName, "User")
                } else {
                    XCTFail("No user found under key 1")
                }
                
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: TimeInterval(GatherlyAPI.delayTime))
    }
    
    func testUpdateUser_updatesAvatarAndBanner() {
        let expectation = XCTestExpectation(description: "User avatar and banner are updated")
        
        var originalUser = makeSampleUser(id: 1)
        UserDefaultsManager.saveUsers([originalUser.id!: originalUser])
        
        originalUser.avatarImageName = "avatar123.png"
        originalUser.bannerImageName = "banner123.png"
        
        GatherlyAPI.updateUser(originalUser)
            .sink { updatedUser in
                XCTAssertEqual(updatedUser.avatarImageName, "avatar123.png")
                XCTAssertEqual(updatedUser.bannerImageName, "banner123.png")
                
                let storedDict = UserDefaultsManager.loadUsers()
                XCTAssertTrue(storedDict.keys.contains(1))
                
                if let storedUser = storedDict[1] {
                    XCTAssertEqual(storedUser.avatarImageName, "avatar123.png")
                    XCTAssertEqual(storedUser.bannerImageName, "banner123.png")
                } else {
                    XCTFail("No user found under key 1")
                }
                
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: TimeInterval(GatherlyAPI.delayTime + 2))
    }
}
