//
//  User.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/4/25.
//

import Foundation

struct User: Equatable, Hashable {
    var createdTimestamp: Int?
    var deviceToken: String?
    var email: String?
    var eventIDs: [Int]?
    var firstName: String?
    var friendIDs: [Int]?
    var groupIDs: [Int]?
    var id: Int?
    var isEmailEnabled: Bool?
    var lastName: String?
    var phone: String?
    
    //MARK: - Computed Vars
    
    var hasEvents: Bool {
        return !(eventIDs?.isEmpty ?? true)
    }
    
    var hasFriends: Bool {
        return !(friendIDs?.isEmpty ?? true)
    }
    
    var hasGroups: Bool {
        return !(groupIDs?.isEmpty ?? true)
    }
}
