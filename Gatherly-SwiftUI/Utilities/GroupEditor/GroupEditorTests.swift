//
//  GroupEditorTests.swift
//  Gatherly-SwiftUITests
//
//  Created by Sami Alhamad on 4/2/25.
//

import XCTest
@testable import Gatherly_SwiftUI

final class GroupEditorTests: XCTestCase {
    
    // MARK: - Create Group
    
    func testCreateGroup() {
        let existingGroups = [
            UserGroup(id: 1, name: "Group 1", memberIDs: [], leaderID: 1),
            UserGroup(id: 2, name: "Group 2", memberIDs: [], leaderID: 2)
        ]
        
        let createdGroup = GroupEditor.saveGroup(
            name: "New Group",
            memberIDs: [2, 3],
            imageName: "group_image.png",
            bannerImageName: "banner_image.png",
            leaderID: 1
        )
        
        XCTAssertEqual(createdGroup.name, "New Group")
        XCTAssertGreaterThan(createdGroup.id, 0)
        XCTAssertLessThanOrEqual(createdGroup.id, Int(Date().timestamp))
        XCTAssertEqual(createdGroup.leaderID, 1)
        XCTAssertEqual(createdGroup.imageName, "group_image.png")
        XCTAssertEqual(createdGroup.bannerImageName, "banner_image.png")
        XCTAssertEqual(createdGroup.memberIDs, [2, 3])
    }
    
    // MARK: - Update Group
    
    func testUpdateGroup() {
        let original = UserGroup(
            id: 99999,
            name: "Original Name",
            memberIDs: [1, 2],
            leaderID: 4,
            messages: []
        )
        
        let updatedGroup = GroupEditor.saveGroup(
            originalGroup: original,
            name: "Updated Name",
            memberIDs: [1, 2, 3],
            imageName: "new_image.png",
            bannerImageName: "new_banner.png",
            leaderID: 99
        )
        
        XCTAssertEqual(updatedGroup.id, original.id)
        XCTAssertEqual(updatedGroup.leaderID, original.leaderID)
        XCTAssertEqual(updatedGroup.name, "Updated Name")
        XCTAssertEqual(updatedGroup.imageName, "new_image.png")
        XCTAssertEqual(updatedGroup.bannerImageName, "new_banner.png")
        XCTAssertEqual(updatedGroup.memberIDs, [1, 2, 3])
        XCTAssertEqual(updatedGroup.messages, original.messages)
    }
    
    // MARK: - Delete Group
    
    func testDeleteGroup() {
        let groupToDelete = UserGroup(id: 11111, name: "Delete Me", memberIDs: [], leaderID: 1)
        let groupToKeep = UserGroup(id: 22222, name: "Keep Me", memberIDs: [], leaderID: 2)
        
        let groups = [groupToDelete, groupToKeep]
        let updatedGroups = GroupEditor.deleteGroup(from: groups, groupToDelete: groupToDelete)
        
        XCTAssertEqual(updatedGroups.count, 1)
        XCTAssertFalse(updatedGroups.contains { $0.id == groupToDelete.id })
        XCTAssertTrue(updatedGroups.contains { $0.id == groupToKeep.id })
    }
    
    // MARK: - isFormEmpty
    
    func testIsFormEmpty_TrueIfBlank() {
        XCTAssertTrue(GroupEditor.isFormEmpty(name: ""))
        XCTAssertTrue(GroupEditor.isFormEmpty(name: "   "))
    }
    
    func testIsFormEmpty_FalseIfValid() {
        XCTAssertFalse(GroupEditor.isFormEmpty(name: "Gather Team"))
    }
}
