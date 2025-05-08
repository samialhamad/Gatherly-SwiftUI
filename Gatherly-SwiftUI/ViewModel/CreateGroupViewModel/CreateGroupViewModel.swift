//
//  CreateGroupViewModel.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 4/1/25.
//

import Foundation
import SwiftUI

class CreateGroupViewModel: ObservableObject {
    @Published var bannerImage: UIImage? = nil
    @Published var groupImage: UIImage? = nil
    @Published var groupName: String = ""
    @Published var selectedMemberIDs: Set<Int> = []

    // MARK: - Create Group

    func createGroup(leaderID: Int) async -> UserGroup {
        var groupImageName: String? = nil
        var bannerImageName: String? = nil

        if let profileImage = groupImage {
            groupImageName = ImageUtility.saveImageToDocuments(image: profileImage)
        }

        if let banner = bannerImage {
            bannerImageName = ImageUtility.saveImageToDocuments(image: banner)
        }

        return await GatherlyAPI.createGroup(
            name: groupName,
            memberIDs: selectedMemberIDs,
            imageName: groupImageName,
            bannerImageName: bannerImageName,
            leaderID: leaderID
        )
    }

    // MARK: - isFormEmpty

    var isFormEmpty: Bool {
        groupName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

