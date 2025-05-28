//
//  EditGroupViewModelTests.swift
//  Gatherly-SwiftUITests
//
//  Created by Sami Alhamad on 4/3/25.
//

import XCTest
@testable import Gatherly_SwiftUI

final class EditGroupViewModelTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        UserDefaultsManager.removeGroups()
    }
    
    func makeSampleGroup() -> UserGroup {
        UserGroup(
            bannerImageName: nil,
            id: 100,
            imageName: nil,
            leaderID: 1,
            memberIDs: [1, 2],
            name: "Sample Group"
        )
    }
    
    // MARK: - Update Group
    
    func testUpdateGroupName() async {
        let originalGroup = makeSampleGroup()
        let viewModel = EditGroupViewModel(group: originalGroup)
        
        viewModel.group.name = "Updated Group Name"
        let updatedGroup = await viewModel.prepareUpdatedGroup()
        
        XCTAssertEqual(updatedGroup.name, "Updated Group Name")
    }
    
    func testUpdateGroupMembers() async {
        let originalGroup = makeSampleGroup()
        let viewModel = EditGroupViewModel(group: originalGroup)
        
        viewModel.group.memberIDs = [1, 2, 3]
        let updatedGroup = await viewModel.prepareUpdatedGroup()
        
        XCTAssertEqual(Set(updatedGroup.memberIDs), Set([1, 2, 3]))
    }
    
    func testUpdateGroupImage() async {
        let originalGroup = makeSampleGroup()
        let viewModel = EditGroupViewModel(group: originalGroup)
        
        viewModel.groupImage = UIImage(systemName: "person.circle.fill")!
        let updatedGroup = await viewModel.prepareUpdatedGroup()
        
        XCTAssertNotNil(updatedGroup.imageName)
    }
    
    func testUpdateGroupBannerImage() async {
        let originalGroup = makeSampleGroup()
        let viewModel = EditGroupViewModel(group: originalGroup)
        
        viewModel.bannerImage = UIImage(systemName: "star.fill")!
        let updatedGroup = await viewModel.prepareUpdatedGroup()
        
        XCTAssertNotNil(updatedGroup.bannerImageName)
    }
    
    // MARK: - Remove Images
    
    func testRemoveGroupImage() {
        var group = makeSampleGroup()
        group.imageName = "sample_image.png"
        
        let viewModel = EditGroupViewModel(group: group)
        viewModel.groupImage = UIImage(systemName: "person.fill")
        viewModel.removeGroupImage()
        
        XCTAssertNil(viewModel.groupImage)
        XCTAssertNil(viewModel.group.imageName)
    }
    
    func testRemoveBannerImage() {
        var group = makeSampleGroup()
        group.bannerImageName = "sample_banner.png"
        
        let viewModel = EditGroupViewModel(group: group)
        viewModel.bannerImage = UIImage(systemName: "star")
        viewModel.removeBannerImage()
        
        XCTAssertNil(viewModel.bannerImage)
        XCTAssertNil(viewModel.group.bannerImageName)
    }
    
    //MARK: - isFormEmpty
    
    func testIsFormEmptyTrue() {
        let group = makeSampleGroup()
        let viewModel = EditGroupViewModel(group: group)
        
        viewModel.group.name = "   "
        XCTAssertTrue(viewModel.isFormEmpty)
    }
    
    func testIsFormEmptyFalse() {
        let group = makeSampleGroup()
        let viewModel = EditGroupViewModel(group: group)
        
        viewModel.group.name = "Group Name"
        XCTAssertFalse(viewModel.isFormEmpty)
    }
    
    //MARK: - leaderID
    
    func testLeaderIDRemainsUnchanged() async {
        let group = makeSampleGroup()
        let viewModel = EditGroupViewModel(group: group)
        
        XCTAssertEqual(viewModel.leaderID, group.leaderID)
        let updatedGroup = await viewModel.prepareUpdatedGroup()
        XCTAssertEqual(updatedGroup.leaderID, group.leaderID)
    }
}
