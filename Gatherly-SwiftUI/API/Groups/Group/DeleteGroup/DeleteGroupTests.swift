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
