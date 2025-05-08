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
        let original = await GatherlyAPI.createGroup(
            name: "Original Name",
            memberIDs: [1, 2],
            leaderID: 4
        )
        
        let updated = await GatherlyAPI.updateGroup(
            original,
            name: "Updated Name",
            memberIDs: [1, 2, 3],
            imageName: "new_image.png",
            bannerImageName: "new_banner.png"
        )
        
        XCTAssertEqual(updated.id, original.id)
        XCTAssertEqual(updated.leaderID, original.leaderID)
        XCTAssertEqual(updated.name, "Updated Name")
        XCTAssertEqual(updated.imageName, "new_image.png")
        XCTAssertEqual(updated.bannerImageName, "new_banner.png")
        XCTAssertEqual(updated.memberIDs, [1, 2, 3])
        XCTAssertEqual(updated.messages ?? [], original.messages ?? [])
    }
}
