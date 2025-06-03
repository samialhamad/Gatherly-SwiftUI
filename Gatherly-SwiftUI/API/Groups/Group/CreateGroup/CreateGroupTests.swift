//
//  CreateGroupTests.swift
//  Gatherly-SwiftUITests
//
//  Created by Sami Alhamad on 5/8/25.
//

import Combine
import XCTest
@testable import Gatherly_SwiftUI

final class CreateGroupTests: XCTestCase {
    
    var cancellables = Set<AnyCancellable>()
    
    override func setUp() {
        super.setUp()
        UserDefaultsManager.removeGroups()
    }
    
    func testCreateGroup() {
        let expectation = XCTestExpectation(description: "Group is created and stored in UserDefaults")
        
        var newGroup = UserGroup(
            bannerImageName: "banner_image.png",
            id: nil,
            imageName: "group_image.png",
            leaderID: 1,
            memberIDs: [2, 3],
            messages: [],
            name: "New Group"
        )
        
        GatherlyAPI.createGroup(newGroup)
            .sink { createdGroup in
                XCTAssertEqual(createdGroup.name, "New Group")
                XCTAssertNotNil(createdGroup.id)
                
                let groupID = createdGroup.id!
                XCTAssertGreaterThan(groupID, 0)
                XCTAssertEqual(createdGroup.leaderID, 1)
                XCTAssertEqual(createdGroup.imageName, "group_image.png")
                XCTAssertEqual(createdGroup.bannerImageName, "banner_image.png")
                XCTAssertEqual(createdGroup.memberIDs, [2, 3])
                
                let storedDict = UserDefaultsManager.loadGroups()
                
                XCTAssertEqual(storedDict.count, 1)
                XCTAssertTrue(storedDict.keys.contains(groupID))
                
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 3)
    }
}
