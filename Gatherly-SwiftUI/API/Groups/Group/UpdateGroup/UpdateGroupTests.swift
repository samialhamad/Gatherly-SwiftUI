//
//  UpdateGroupTests.swift
//  Gatherly-SwiftUITests
//
//  Created by Sami Alhamad on 5/8/25.
//

import XCTest
@testable import Gatherly_SwiftUI

final class UpdateGroupTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        UserDefaultsManager.removeGroups()
    }
    
    func testUpdateGroup() async {
        var original = UserGroup(
            id: nil,
            leaderID: 4,
            memberIDs: [1, 2],
            messages: [],
            name: "Original Name"
        )
        
        original = await GatherlyAPI.createGroup(original)
        
        var updated = original
        updated.name = "Updated Name"
        updated.memberIDs = [1, 2, 3]
        updated.imageName = "new_image.png"
        updated.bannerImageName = "new_banner.png"
        
        let result = await GatherlyAPI.updateGroup(updated)
        
        XCTAssertEqual(result.id, original.id)
        XCTAssertEqual(result.leaderID, original.leaderID)
        XCTAssertEqual(result.name, "Updated Name")
        XCTAssertEqual(result.imageName, "new_image.png")
        XCTAssertEqual(result.bannerImageName, "new_banner.png")
        XCTAssertEqual(result.memberIDs, [1, 2, 3])
        XCTAssertEqual(result.messages ?? [], original.messages ?? [])
    }
}
