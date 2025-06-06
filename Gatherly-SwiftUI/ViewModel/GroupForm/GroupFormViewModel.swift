//
//  GroupFormViewModel.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 6/5/25.
//

import Foundation
import SwiftUI

class GroupFormViewModel: ObservableObject {
    @Published var group: UserGroup
    @Published var selectedBannerImage: UIImage?
    @Published var selectedGroupImage: UIImage?
    
    private let currentUserID: Int?
    let mode: Mode
    
    enum Mode: Equatable {
        case create
        case edit(group: UserGroup)
    }
    
    init(
        mode: Mode,
        currentUserID: Int? = nil,
        existingGroup: UserGroup? = nil
    ) {
        self.mode = mode
        
        switch mode {
        case .create:
            let leaderID = currentUserID ?? 1
            self.currentUserID = currentUserID
            
            self.group = UserGroup(
                id: nil,
                leaderID: leaderID,
                memberIDs: [],
                messages: [],
                name: nil
            )
            
        case .edit(let group):
            self.group = group
            self.currentUserID = currentUserID
            
            if let groupImageName = group.imageName {
                self.selectedGroupImage = ImageUtility.loadImageFromDocuments(named: groupImageName)
            } else {
                self.selectedGroupImage = nil
            }
            
            if let bannerImageName = group.bannerImageName {
                self.selectedBannerImage = ImageUtility.loadImageFromDocuments(named: bannerImageName)
            } else {
                self.selectedBannerImage = nil
            }
        }
    }
    
    // MARK: – Computed properties
    
    var isFormEmpty: Bool {
        (group.name ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    // MARK: – Remove Images
    
    func removeGroupImage() {
        if let oldImage = group.imageName {
            ImageUtility.deleteImageFromDocuments(named: oldImage)
        }
        selectedGroupImage = nil
        group.imageName = nil
    }
    
    func removeBannerImage() {
        if let oldBannerImageName = group.bannerImageName {
            ImageUtility.deleteImageFromDocuments(named: oldBannerImageName)
        }
        selectedBannerImage = nil
        group.bannerImageName = nil
    }
    
    // MARK: – Prepare
    
    func prepareUpdatedGroup() async -> UserGroup {
        await MainActor.run {
            if let newGroupImage = selectedGroupImage {
                self.group.imageName = ImageUtility.saveImageToDocuments(image: newGroupImage)
            } else {
                group.imageName = nil
            }
            
            if let newBannerImage = selectedBannerImage {
                group.bannerImageName = ImageUtility.saveImageToDocuments(image: newBannerImage)
            } else {
                group.bannerImageName = nil
            }
        }
        
        return group
    }
}
