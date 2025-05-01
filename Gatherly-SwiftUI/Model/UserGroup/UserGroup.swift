//
//  UserGroup.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/27/25.
//

import Foundation

struct UserGroup: Codable, Identifiable, Equatable {
    var bannerImageName: String? = nil
    var id: Int
    var imageName: String? = nil
    var leaderID: Int
    var memberIDs: [Int]
    var messages: [Message]?
    var name: String

    // MARK: - Computed Vars
    
    var hasMessages: Bool {
        return !(messages?.isEmpty ?? true)
    }
    
    var hasMembers: Bool {
        return !memberIDs.isEmpty
    }
}
