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
    var id: Int?
    var isEmailEnabled: Bool?
    var lastName: String?
    var phone: String?
            
    //MARK: - Computed Vars
    
    var hasFriends: Bool {
        return !(friendIDs?.isEmpty ?? true)
    }
    
    var hasEvents: Bool {
        return !(eventIDs?.isEmpty ?? true)
    }
}
