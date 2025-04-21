//
//  CreateGroupViewModelTests.swift
//  Gatherly-SwiftUITests
//
//  Created by Sami Alhamad on 4/2/25.
//

import XCTest
@testable import Gatherly_SwiftUI

final class CreateGroupViewModelTests: XCTestCase {
    
    func testCreateGroup() {
        let viewModel = CreateGroupViewModel()
        viewModel.groupName = "Test Group"
        viewModel.selectedMemberIDs = [2, 3]
        
        let testProfileImage = UIImage(systemName: "person.circle")!
        let testBannerImage = UIImage(systemName: "photo")!
        viewModel.groupImage = testProfileImage
        viewModel.bannerImage = testBannerImage
        
        let leaderID = 1
        let existingGroups = [
            UserGroup(id: 1, name: "Existing Group 1", memberIDs: [2], leaderID: 1),
            UserGroup(id: 2, name: "Existing Group 2", memberIDs: [3], leaderID: 1)
        ]
        
        let group = viewModel.createGroup(leaderID: leaderID, existingGroups: existingGroups)
        
        XCTAssertEqual(group.name, "Test Group")
        XCTAssertEqual(group.leaderID, leaderID)
        XCTAssertEqual(group.memberIDs, [2, 3])
        XCTAssertEqual(group.id, 3)
        XCTAssertNotNil(group.imageName)
        XCTAssertNotNil(group.bannerImageName)
    }
}
