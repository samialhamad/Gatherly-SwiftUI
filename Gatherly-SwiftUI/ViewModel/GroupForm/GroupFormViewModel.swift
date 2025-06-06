//
//  GroupFormViewModel.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 6/5/25.
//

import Foundation
import SwiftUI

enum GroupFormMode {
    case create
    case edit
}

class GroupFormViewModel: ObservableObject {
    @Published var group: UserGroup
    @Published var groupImage: UIImage?
    @Published var bannerImage: UIImage?
    
    private let currentUserID: Int?
    private let original: UserGroup?
    let mode: GroupFormMode
    
    init(
        mode: GroupFormMode,
        currentUserID: Int? = nil,
        existingGroup: UserGroup? = nil
    ) {
        self.mode = mode
        
        switch mode {
        case .create:
            guard let currentUserID else {
                fatalError("GroupFormViewModel.init: you must pass a non-nil currentUserID when mode == .create")
            }
            self.currentUserID = currentUserID
            self.original = nil
            
            self.group = UserGroup(
                id: nil,
                leaderID: currentUserID,
                memberIDs: [],
                messages: [],
                name: nil
            )
            
        case .edit:
            guard let existingGroup else {
                fatalError("GroupFormViewModel.init: you must pass a non-nil existingGroup when mode == .edit")
            }
            self.currentUserID = nil
            self.original = existingGroup
            
            self.group = existingGroup
            
            if let imageName = existingGroup.imageName {
                self.groupImage = ImageUtility.loadImageFromDocuments(named: imageName)
            }
            if let bannerImageName = existingGroup.bannerImageName {
                self.bannerImage = ImageUtility.loadImageFromDocuments(named: bannerImageName)
            }
        }
    }
    
    // MARK: – Computed properties
    
    var isFormEmpty: Bool {
        (group.name ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var originalGroup: UserGroup? {
        original
    }
    
    // MARK: – Remove Images
    
    func removeGroupImage() {
        if mode == .edit, let oldImage = original?.imageName {
            ImageUtility.deleteImageFromDocuments(named: oldImage)
        }
        groupImage = nil
        group.imageName = nil
    }
    
    func removeBannerImage() {
        if mode == .edit, let oldBanner = original?.bannerImageName {
            ImageUtility.deleteImageFromDocuments(named: oldBanner)
        }
        bannerImage = nil
        group.bannerImageName = nil
    }
    
    // MARK: – Prepare
    
    func prepareGroup() async -> UserGroup {
        await MainActor.run {
            if let newImage = self.groupImage {
                self.group.imageName = ImageUtility.saveImageToDocuments(image: newImage)
            } else {
                if mode == .edit, let oldName = original?.imageName {
                    ImageUtility.deleteImageFromDocuments(named: oldName)
                }
                self.group.imageName = nil
            }
            
            if let newBanner = self.bannerImage {
                self.group.bannerImageName = ImageUtility.saveImageToDocuments(image: newBanner)
            } else {
                if mode == .edit, let oldBanner = original?.bannerImageName {
                    ImageUtility.deleteImageFromDocuments(named: oldBanner)
                }
                self.group.bannerImageName = nil
            }
        }
        
        return group
    }
}
