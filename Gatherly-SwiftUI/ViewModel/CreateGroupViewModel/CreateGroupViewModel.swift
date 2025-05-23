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
    @Published var group: UserGroup
    @Published var groupImage: UIImage? = nil
    
    init(currentUserID: Int) {
        self.group = UserGroup(
            id: nil,
            leaderID: currentUserID,
            memberIDs: [],
            messages: [],
            name: nil
        )
    }
    
    // MARK: - Create Group
    
    func createGroup() async -> UserGroup {
        await MainActor.run {
            if let image = groupImage {
                group.imageName = ImageUtility.saveImageToDocuments(image: image)
            }
            
            if let banner = bannerImage {
                group.bannerImageName = ImageUtility.saveImageToDocuments(image: banner)
            }
        }
        
        return await withCheckedContinuation { continuation in
            _ = GatherlyAPI.createGroup(group)
                .sink { createdGroup in
                    continuation.resume(returning: createdGroup)
                }
        }
    }
    
    // MARK: - isFormEmpty
    
    var isFormEmpty: Bool {
        (group.name ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

