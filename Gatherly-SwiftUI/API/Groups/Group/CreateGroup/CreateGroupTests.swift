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
        let group = await GatherlyAPI.createGroup(
            name: "New Group",
            memberIDs: [2, 3],
            imageName: "group_image.png",
            bannerImageName: "banner_image.png",
            leaderID: 1
        )
        
        XCTAssertEqual(group.name, "New Group")
        XCTAssertGreaterThan(group.id, 0)
        XCTAssertEqual(group.leaderID, 1)
        XCTAssertEqual(group.imageName, "group_image.png")
        XCTAssertEqual(group.bannerImageName, "banner_image.png")
        XCTAssertEqual(group.memberIDs, [2, 3])
    }
}
