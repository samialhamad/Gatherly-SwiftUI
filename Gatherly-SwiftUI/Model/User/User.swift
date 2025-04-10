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

extension User {
    init(from syncedContact: SyncedContact, id: Int) {
        self.init(
            createdTimestamp: Int(Date().timeIntervalSince1970),
            deviceToken: nil,
            email: nil,
            eventIDs: [],
            firstName: syncedContact.fullName.components(separatedBy: " ").first,
            friendIDs: [],
            id: id,
            isEmailEnabled: false,
            lastName: syncedContact.fullName.components(separatedBy: " ").dropFirst().joined(separator: " "),
            phone: syncedContact.phoneNumber
        )
    }
}
