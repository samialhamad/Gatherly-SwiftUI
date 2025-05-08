//
//  CreateGroupViewModelTests.swift
//  Gatherly-SwiftUITests
//
//  Created by Sami Alhamad on 4/2/25.
//

import XCTest
@testable import Gatherly_SwiftUI

final class CreateGroupViewModelTests: XCTestCase {

    override func setUp() {
        super.setUp()
        UserDefaultsManager.removeGroups()
    }
    
    // MARK: - Create Group

    func testCreateGroup() async {
        let viewModel = CreateGroupViewModel()
        viewModel.groupName = "Test Group"
        viewModel.selectedMemberIDs = [2, 3]

        let testProfileImage = UIImage(systemName: "person.circle")!
        let testBannerImage = UIImage(systemName: "photo")!
        viewModel.groupImage = testProfileImage
        viewModel.bannerImage = testBannerImage

        let leaderID = 1
        let group = await viewModel.createGroup(leaderID: leaderID)

        XCTAssertEqual(group.name, "Test Group")
        XCTAssertEqual(group.leaderID, leaderID)
        XCTAssertEqual(group.memberIDs, [2, 3])
        XCTAssertGreaterThan(group.id, 0)
        XCTAssertLessThanOrEqual(group.id, Int(Date().timestamp))
        XCTAssertNotNil(group.imageName)
        XCTAssertNotNil(group.bannerImageName)
    }
    
    //MARK: - isFormEmpty
    
    func testIsFormEmpty() {
        let viewModel = CreateGroupViewModel()
        XCTAssertTrue(viewModel.isFormEmpty)
        
        viewModel.groupName = "   "
        XCTAssertTrue(viewModel.isFormEmpty)
        
        viewModel.groupName = "Study Buddies"
        XCTAssertFalse(viewModel.isFormEmpty)
    }
}
