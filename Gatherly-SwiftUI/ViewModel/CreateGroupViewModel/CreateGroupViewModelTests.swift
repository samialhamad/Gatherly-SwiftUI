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
        
        let creatorID = 1
        let group = viewModel.createGroup(creatorID: creatorID)
        
        XCTAssertEqual(group.name, "Test Group")
        XCTAssertEqual(group.leaderID, creatorID)
        XCTAssertEqual(group.memberIDs, [2, 3])
        XCTAssertNotNil(group.imageName)
        XCTAssertNotNil(group.bannerImageName)
    }
}
