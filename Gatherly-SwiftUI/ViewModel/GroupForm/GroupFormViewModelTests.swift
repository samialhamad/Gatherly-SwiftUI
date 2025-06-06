//
//  GroupFormViewModelTests.swift
//  Gatherly-SwiftUITests
//
//  Created by Sami Alhamad on 6/5/25.
//

import XCTest
@testable import Gatherly_SwiftUI

final class GroupFormViewModelTests: XCTestCase {
    
    // MARK: - Create Mode
    
    func testCreateInitialState() {
        let viewModel = GroupFormViewModel(mode: .create, currentUserID: 1)
        XCTAssertNil(viewModel.group.id)
        XCTAssertEqual(viewModel.group.leaderID, 1)
        XCTAssertTrue(viewModel.group.memberIDs.isEmpty)
        XCTAssertNil(viewModel.group.name)
    }
    
    func testCreateIsFormEmpty() {
        let viewModel = GroupFormViewModel(mode: .create, currentUserID: 1)
        XCTAssertTrue(viewModel.isFormEmpty)
        
        viewModel.group.name = "   "
        XCTAssertTrue(viewModel.isFormEmpty)
        
        viewModel.group.name = "Run Club"
        XCTAssertFalse(viewModel.isFormEmpty)
    }
    
    func testCreatePrepareGroupSetsImages() async {
        let viewModel = GroupFormViewModel(mode: .create, currentUserID: 5)
        viewModel.group.name = "Test Group"
        viewModel.group.memberIDs = [2, 3]
        
        viewModel.groupImage = UIImage(systemName: "person.circle")
        viewModel.bannerImage = UIImage(systemName: "star.fill")
        
        let preparedGroup = await viewModel.prepareGroup()
        XCTAssertEqual(preparedGroup.name, "Test Group")
        XCTAssertEqual(Set(preparedGroup.memberIDs), Set([2, 3]))
        XCTAssertEqual(preparedGroup.leaderID, 5)
        XCTAssertNotNil(preparedGroup.imageName)
        XCTAssertNotNil(preparedGroup.bannerImageName)
    }
    
    // MARK: - Edit Mode
    
    func testEditIsFormEmpty() {
        let original = UserGroup(
            id: 100,
            leaderID: 2,
            memberIDs: [2, 3],
            name: "Original"
        )
        let viewModel = GroupFormViewModel(mode: .edit, existingGroup: original)
        
        XCTAssertFalse(viewModel.isFormEmpty)
        
        viewModel.group.name = "   "
        XCTAssertTrue(viewModel.isFormEmpty)
    }
    
    func testRemoveGroupImageAndBanner() {
        var originalGroup = UserGroup(
            id: 200,
            leaderID: 2,
            memberIDs: [2, 3],
            name: "Original"
        )
        originalGroup.imageName = "oldImage.png"
        originalGroup.bannerImageName = "oldBanner.png"
        
        let viewModel = GroupFormViewModel(mode: .edit, existingGroup: originalGroup)
        
        viewModel.groupImage = UIImage(systemName: "person.fill")
        viewModel.bannerImage = UIImage(systemName: "star")
        
        viewModel.removeGroupImage()
        XCTAssertNil(viewModel.groupImage)
        XCTAssertNil(viewModel.group.imageName)
        
        viewModel.removeBannerImage()
        XCTAssertNil(viewModel.bannerImage)
        XCTAssertNil(viewModel.group.bannerImageName)
    }
    
    func testEditPrepareGroupSetsNewImages() async {
        let originalGroup = UserGroup(
            id: 400,
            leaderID: 4,
            memberIDs: [4,5],
            name: "EditMe"
        )
        let viewModel = GroupFormViewModel(mode: .edit, existingGroup: originalGroup)
        
        viewModel.groupImage = UIImage(systemName: "pencil.circle")
        viewModel.bannerImage = UIImage(systemName: "sun.max.fill")
        
        let preparedGroup = await viewModel.prepareGroup()
        XCTAssertNotNil(preparedGroup.imageName)
        XCTAssertNotNil(preparedGroup.bannerImageName)
    }
}
