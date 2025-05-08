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
        let viewModel = CreateGroupViewModel(currentUserID: 1)
        viewModel.group.name = "Test Group"
        viewModel.group.memberIDs = [2, 3]
        
        viewModel.groupImage = UIImage(systemName: "person.circle")
        viewModel.bannerImage = UIImage(systemName: "photo")
        
        let createdGroup = await viewModel.createGroup()
        
        XCTAssertEqual(createdGroup.name, "Test Group")
        XCTAssertEqual(createdGroup.leaderID, 1)
        XCTAssertEqual(createdGroup.memberIDs, [2, 3])
        XCTAssertNotNil(createdGroup.id)
        XCTAssertGreaterThan(createdGroup.id ?? 0, 0)
        XCTAssertNotNil(createdGroup.imageName)
        XCTAssertNotNil(createdGroup.bannerImageName)
    }
    
    //MARK: - isFormEmpty
    
    func testIsFormEmpty() {
        let viewModel = CreateGroupViewModel(currentUserID: 1)
        
        XCTAssertTrue(viewModel.isFormEmpty)
        
        viewModel.group.name = "   "
        XCTAssertTrue(viewModel.isFormEmpty)
        
        viewModel.group.name = "Study Buddies"
        XCTAssertFalse(viewModel.isFormEmpty)
    }
}
