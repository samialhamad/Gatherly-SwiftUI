//
//  EditGroupViewModelTests.swift
//  Gatherly-SwiftUITests
//
//  Created by Sami Alhamad on 4/3/25.
//

import XCTest
@testable import Gatherly_SwiftUI

final class EditGroupViewModelTests: XCTestCase {
    
    //helper func
    func makeSampleGroup() -> UserGroup {
        UserGroup(
            id: 100,
            name: "Sample Group",
            memberIDs: [1, 2],
            leaderID: 1,
            imageName: nil,
            bannerImageName: nil
        )
    }
    
    func testUpdatedGroupName() {
        let originalGroup = makeSampleGroup()
        let viewModel = EditGroupViewModel(group: originalGroup)
        
        viewModel.groupName = "Updated Group Name"
        
        let updatedGroup = viewModel.updatedGroup()
        
        XCTAssertEqual(updatedGroup.name, "Updated Group Name")
    }
    
    func testUpdatedGroupMembers() {
        let originalGroup = makeSampleGroup()
        let viewModel = EditGroupViewModel(group: originalGroup)
        
        viewModel.selectedMemberIDs = Set([1, 2, 3])
        
        let updatedGroup = viewModel.updatedGroup()
        
        XCTAssertEqual(Set(updatedGroup.memberIDs), Set([1, 2, 3]))
    }
    
    func testUpdateGroupImage() {
        let originalGroup = makeSampleGroup()
        let viewModel = EditGroupViewModel(group: originalGroup)
        
        viewModel.groupImage = UIImage(systemName: "person.circle.fill")!
        let updatedGroup = viewModel.updatedGroup()
        
        XCTAssertNotNil(updatedGroup.imageName)
    }
    
    func testUpdateGroupBannerImage() {
        let originalGroup = makeSampleGroup()
        let viewModel = EditGroupViewModel(group: originalGroup)
        
        viewModel.bannerImage = UIImage(systemName: "star.fill")!
        let updatedGroup = viewModel.updatedGroup()
        
        XCTAssertNotNil(updatedGroup.bannerImageName)
    }
    
    func testRemoveGroupImage() {
        var group = makeSampleGroup()
        group.imageName = "sample_image.png"
        
        let viewModel = EditGroupViewModel(group: group)
        viewModel.groupImage = UIImage(systemName: "person.fill")
        
        viewModel.removeGroupImage()
        
        XCTAssertNil(viewModel.groupImage)
    }
    
    func testRemoveBannerImage() {
        var group = makeSampleGroup()
        group.bannerImageName = "sample_banner.png"
        
        let viewModel = EditGroupViewModel(group: group)
        viewModel.bannerImage = UIImage(systemName: "star")
        
        viewModel.removeBannerImage()
        
        XCTAssertNil(viewModel.bannerImage)
    }
    
    func testIsFormEmptyTrue() {
        let group = makeSampleGroup()
        let viewModel = EditGroupViewModel(group: group)
        
        viewModel.groupName = "   "
        XCTAssertTrue(viewModel.isFormEmpty)
    }
    
    func testIsFormEmptyFalse() {
        let group = makeSampleGroup()
        let viewModel = EditGroupViewModel(group: group)
        
        viewModel.groupName = "Group Name"
        XCTAssertFalse(viewModel.isFormEmpty)
    }
    
    func testLeaderIDRemainsUnchanged() {
        let group = makeSampleGroup()
        let viewModel = EditGroupViewModel(group: group)
        
        XCTAssertEqual(viewModel.leaderID, group.leaderID)
        let updatedGroup = viewModel.updatedGroup()
        XCTAssertEqual(updatedGroup.leaderID, group.leaderID)
    }
}
