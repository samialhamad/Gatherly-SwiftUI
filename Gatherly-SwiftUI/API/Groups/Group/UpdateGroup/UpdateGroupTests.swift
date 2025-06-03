//
//  UpdateGroupTests.swift
//  Gatherly-SwiftUITests
//
//  Created by Sami Alhamad on 5/8/25.
//

import Combine
import XCTest
@testable import Gatherly_SwiftUI

final class UpdateGroupTests: XCTestCase {
    
    var cancellables = Set<AnyCancellable>()
    
    override func setUp() {
        super.setUp()
        UserDefaultsManager.removeGroups()
    }
    
    override func tearDown() {
        UserDefaultsManager.removeGroups()
        super.tearDown()
    }
    
    func testUpdateGroup() {
        let expectation = XCTestExpectation(description: "Group is updated and saved")
        
        let original = UserGroup(
            bannerImageName: "banner.png",
            id: 123,
            imageName: "original.png",
            leaderID: 4,
            memberIDs: [1, 2],
            messages: [],
            name: "Original Name"
        )
        
        let initialDict: [Int: UserGroup] = [
            original.id!: original
        ]
        UserDefaultsManager.saveGroups(initialDict)
        
        var updated = original
        updated.name = "Updated Name"
        updated.memberIDs = [1, 2, 3]
        updated.imageName = "new_image.png"
        updated.bannerImageName = "new_banner.png"
        
        GatherlyAPI.updateGroup(updated)
            .sink { result in
                XCTAssertEqual(result.id, original.id)
                XCTAssertEqual(result.leaderID, original.leaderID)
                XCTAssertEqual(result.name, "Updated Name")
                XCTAssertEqual(result.imageName, "new_image.png")
                XCTAssertEqual(result.bannerImageName, "new_banner.png")
                XCTAssertEqual(result.memberIDs, [1, 2, 3])
                XCTAssertEqual(result.messages ?? [], original.messages ?? [])
                
                let storedDict = UserDefaultsManager.loadGroups()
                
                XCTAssertEqual(storedDict.count, 1)
                XCTAssertTrue(storedDict.keys.contains(original.id!))
                
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 2)
    }
}
