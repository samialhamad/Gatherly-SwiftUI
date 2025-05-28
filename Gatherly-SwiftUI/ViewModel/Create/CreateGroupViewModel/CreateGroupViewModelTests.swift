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
        
        let group = await viewModel.preparedGroup()
        
        XCTAssertEqual(group.name, "Test Group")
        XCTAssertEqual(group.leaderID, 1)
        XCTAssertEqual(group.memberIDs, [2, 3])
        XCTAssertNotNil(group.imageName)
        XCTAssertNotNil(group.bannerImageName)
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
