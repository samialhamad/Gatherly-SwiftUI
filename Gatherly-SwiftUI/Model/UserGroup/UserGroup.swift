//
//  UserGroup.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/27/25.
//

import Foundation

struct UserGroup: Codable, Identifiable, Equatable {
    var id: Int
    var name: String
    var memberIDs: [Int]
    var leaderID: Int
    var messages: [Message]?
    var imageName: String? = nil
    var bannerImageName: String? = nil

    // MARK: - Computed Vars
    
    var hasMessages: Bool {
        return !(messages?.isEmpty ?? true)
    }
    
    var hasMembers: Bool {
        return !memberIDs.isEmpty
    }
}
