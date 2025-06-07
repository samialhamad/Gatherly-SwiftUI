//
//  GroupDetailViewModel.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 6/7/25.
//

import SwiftUI

class GroupDetailViewModel: ObservableObject {
    func friendsDict(for users: [User]) -> [Int: User] {
        users.keyedBy(\.id)
    }
    
    func group(forID id: Int, in groups: [UserGroup]) -> UserGroup? {
        groups.first { $0.id == id }
    }
}
