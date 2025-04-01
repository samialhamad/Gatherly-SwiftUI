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
}
