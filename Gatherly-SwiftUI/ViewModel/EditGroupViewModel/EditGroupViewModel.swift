//
//  EditGroupViewModel.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 4/3/25.
//

import Foundation
import SwiftUI

class EditGroupViewModel: ObservableObject {
    @Published var bannerImage: UIImage?
    @Published var groupImage: UIImage?
    @Published var groupName: String
    @Published var selectedMemberIDs: Set<Int>
    
    private let original: UserGroup
    
    var originalGroup: UserGroup {
        original
    }
    
    init(group: UserGroup) {
        self.original = group
        
        self.groupName = group.name
        self.selectedMemberIDs = Set(group.memberIDs)
        self.groupImage = group.imageName.flatMap { ImageUtility.loadImageFromDocuments(named: $0) }
        self.bannerImage = group.bannerImageName.flatMap { ImageUtility.loadImageFromDocuments(named: $0) }
    }
    
    func updatedGroup() -> UserGroup {
        var updatedImageName = original.imageName
        var updatedBannerName = original.bannerImageName
        
        if let newGroupImage = groupImage {
            updatedImageName = ImageUtility.saveImageToDocuments(image: newGroupImage)
        }
        
        if let newBanner = bannerImage {
            updatedBannerName = ImageUtility.saveImageToDocuments(image: newBanner)
        }
        
        return GroupEditor.saveGroup(
            originalGroup: original,
            name: groupName,
            memberIDs: selectedMemberIDs,
            imageName: updatedImageName,
            bannerImageName: updatedBannerName,
            leaderID: original.leaderID
        )
    }
    
    func removeGroupImage() {
        if let imageName = original.imageName {
            ImageUtility.deleteImageFromDocuments(named: imageName)
        }
        groupImage = nil
    }
    
    func removeBannerImage() {
        if let bannerName = original.bannerImageName {
            ImageUtility.deleteImageFromDocuments(named: bannerName)
        }
        bannerImage = nil
    }
    
    var isFormEmpty: Bool {
        GroupEditor.isFormEmpty(name: groupName)
    }
    
    var leaderID: Int {
        original.leaderID
    }
}
