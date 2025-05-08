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

    var originalGroup: UserGroup { original }

    init(group: UserGroup) {
        self.original = group
        self.groupName = group.name ?? ""
        self.selectedMemberIDs = Set(group.memberIDs)
        self.groupImage = group.imageName.flatMap { ImageUtility.loadImageFromDocuments(named: $0) }
        self.bannerImage = group.bannerImageName.flatMap { ImageUtility.loadImageFromDocuments(named: $0) }
    }

    // MARK: - Update Group

    func updateGroup() async -> UserGroup {
        var updatedImageName = original.imageName
        var updatedBannerName = original.bannerImageName

        if let newGroupImage = groupImage {
            updatedImageName = ImageUtility.saveImageToDocuments(image: newGroupImage)
        }

        if let newBanner = bannerImage {
            updatedBannerName = ImageUtility.saveImageToDocuments(image: newBanner)
        }

        return await GatherlyAPI.updateGroup(
            original,
            name: groupName,
            memberIDs: selectedMemberIDs,
            imageName: updatedImageName,
            bannerImageName: updatedBannerName
        )
    }

    // MARK: - Image Removal

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

    // MARK: - isFormEmpty

    var isFormEmpty: Bool {
        groupName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    // MARK: - leaderID

    var leaderID: Int {
        original.leaderID
    }
}

