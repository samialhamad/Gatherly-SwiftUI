//
//  CreateGroupViewModel.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 4/1/25.
//

import Foundation
import SwiftUI

class CreateGroupViewModel: ObservableObject {
    @Published var selectedMemberIDs: Set<Int> = []
    @Published var groupName: String = ""
    @Published var groupImage: UIImage? = nil
    @Published var bannerImage: UIImage? = nil
    
    func createGroup(creatorID: Int) -> UserGroup {
        var groupImageName: String? = nil
        var bannerImageName: String? = nil
        
        if let profileImage = groupImage {
            groupImageName = ImageUtility.saveImageToDocuments(image: profileImage)
        }
        
        if let banner = bannerImage {
            bannerImageName = ImageUtility.saveImageToDocuments(image: banner)
        }
        
        return GroupEditor.saveGroup(
            name: groupName,
            memberIDs: selectedMemberIDs,
            imageName: groupImageName,
            bannerImageName: bannerImageName,
            creatorID: creatorID
        )
    }
}
