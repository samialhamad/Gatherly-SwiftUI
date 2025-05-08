//
//  CreateGroupTests.swift
//  Gatherly-SwiftUITests
//
//  Created by Sami Alhamad on 5/8/25.
//

import XCTest
@testable import Gatherly_SwiftUI


final class CreateGroupTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        UserDefaultsManager.removeGroups()
    }
    
    func testCreateGroup() async {
        var newGroup = UserGroup(
            bannerImageName: "banner_image.png",
            id: nil,
            imageName: "group_image.png",
            leaderID: 1,
            memberIDs: [2, 3],
            messages: [],
            name: "New Group"
        )
        
        let createdGroup = await GatherlyAPI.createGroup(newGroup)
        
        XCTAssertEqual(createdGroup.name, "New Group")
        XCTAssertNotNil(createdGroup.id)
        XCTAssertGreaterThan(createdGroup.id ?? 0, 0)
        XCTAssertEqual(createdGroup.leaderID, 1)
        XCTAssertEqual(createdGroup.imageName, "group_image.png")
        XCTAssertEqual(createdGroup.bannerImageName, "banner_image.png")
        XCTAssertEqual(createdGroup.memberIDs, [2, 3])
    }
}
