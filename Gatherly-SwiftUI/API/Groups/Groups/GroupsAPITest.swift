//
//  GroupsAPITest.swift
//  Gatherly-SwiftUITests
//
//  Created by Sami Alhamad on 5/7/25.
//

import XCTest
@testable import Gatherly_SwiftUI

final class GroupsAPITests: XCTestCase {

    override func setUp() {
        super.setUp()
        UserDefaultsManager.removeGroups()
    }

    // MARK: - Create Group

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

    // MARK: - Update Group

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

    // MARK: - Delete Group

    func testDeleteGroup() async {
        let groupToDelete = await GatherlyAPI.createGroup(
            name: "Delete Me",
            memberIDs: [],
            leaderID: 1
        )

        let groupToKeep = await GatherlyAPI.createGroup(
            name: "Keep Me",
            memberIDs: [],
            leaderID: 2
        )

        let allGroupsBefore = UserDefaultsManager.loadGroups()
        XCTAssertEqual(allGroupsBefore.count, 2)

        let updatedGroups = await GatherlyAPI.deleteGroup(groupToDelete)

        XCTAssertEqual(updatedGroups.count, 1)
        XCTAssertFalse(updatedGroups.contains(where: { $0.id == groupToDelete.id }))
        XCTAssertTrue(updatedGroups.contains(where: { $0.id == groupToKeep.id }))
    }
}
