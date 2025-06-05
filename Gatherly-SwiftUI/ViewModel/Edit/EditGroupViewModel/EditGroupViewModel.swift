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
    @Published var group: UserGroup
    @Published var groupImage: UIImage?
    
    
    private let original: UserGroup
    
    var originalGroup: UserGroup { original }
    
    init(group: UserGroup) {
        self.original = group
        self.group = group
        
        if let groupImageName = group.imageName {
            self.groupImage = ImageUtility.loadImageFromDocuments(named: groupImageName)
        }
        
        if let bannerImageName = group.bannerImageName {
            self.bannerImage = ImageUtility.loadImageFromDocuments(named: bannerImageName)
        }
    }
    
    // MARK: - Preapre Group
    
    func prepareUpdatedGroup() async -> UserGroup {
        await MainActor.run {
            if let newGroupImage = groupImage {
                group.imageName = ImageUtility.saveImageToDocuments(image: newGroupImage)
            } else {
                group.imageName = nil
            }

            if let newBanner = bannerImage {
                group.bannerImageName = ImageUtility.saveImageToDocuments(image: newBanner)
            } else {
                group.bannerImageName = nil
            }
        }
        
        return group
    }
    
    // MARK: - Image Removal
    
    func removeGroupImage() {
        if let imageName = group.imageName {
            ImageUtility.deleteImageFromDocuments(named: imageName)
        }
        groupImage = nil
        group.imageName = nil
    }
    
    func removeBannerImage() {
        if let bannerName = group.bannerImageName {
            ImageUtility.deleteImageFromDocuments(named: bannerName)
        }
        bannerImage = nil
        group.bannerImageName = nil
    }
    
    // MARK: - isFormEmpty
    
    var isFormEmpty: Bool {
        (group.name ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    // MARK: - leaderID
    
    var leaderID: Int {
        group.leaderID
    }
}

