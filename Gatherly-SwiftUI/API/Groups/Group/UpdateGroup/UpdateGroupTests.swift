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
        
        UserDefaultsManager.saveGroups([original])
        
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
                
                let storedGroups = UserDefaultsManager.loadGroups()
                XCTAssertEqual(storedGroups.count, 1)
                XCTAssertEqual(storedGroups.first?.name, "Updated Name")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 2)
    }
}
