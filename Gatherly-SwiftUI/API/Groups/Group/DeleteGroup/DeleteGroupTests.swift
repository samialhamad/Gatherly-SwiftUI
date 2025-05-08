//
//  DeleteGroupTests.swift
//  Gatherly-SwiftUITests
//
//  Created by Sami Alhamad on 5/8/25.
//

import XCTest
@testable import Gatherly_SwiftUI

final class DeleteGroupTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        UserDefaultsManager.removeGroups()
    }
    
    func testDeleteGroup() async {
        let groupToDelete = UserGroup(
            id: nil,
            leaderID: 1,
            memberIDs: [],
            messages: [],
            name: "Delete Me"
        )
        
        let groupToKeep = UserGroup(
            id: nil,
            leaderID: 2,
            memberIDs: [],
            messages: [],
            name: "Keep Me"
        )
        
        let savedDeleteGroup = await GatherlyAPI.createGroup(groupToDelete)
        let savedKeepGroup = await GatherlyAPI.createGroup(groupToKeep)
        
        let allGroupsBefore = UserDefaultsManager.loadGroups()
        XCTAssertEqual(allGroupsBefore.count, 2)
        
        let updatedGroups = await GatherlyAPI.deleteGroup(savedDeleteGroup)
        
        XCTAssertEqual(updatedGroups.count, 1)
        XCTAssertFalse(updatedGroups.contains(where: { $0.id == savedDeleteGroup.id }))
        XCTAssertTrue(updatedGroups.contains(where: { $0.id == savedKeepGroup.id }))
    }
}
