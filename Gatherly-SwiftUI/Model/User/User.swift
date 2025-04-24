//
//  User.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/4/25.
//

import Foundation

class User: ObservableObject, Identifiable, Equatable, Hashable {
    @Published var avatarImageName: String?
    @Published var bannerImageName: String?
    @Published var createdTimestamp: Int?
    @Published var deviceToken: String?
    @Published var email: String?
    @Published var eventIDs: [Int]?
    @Published var firstName: String?
    @Published var friendIDs: [Int]?
    @Published var groupIDs: [Int]?
    @Published var id: Int?
    @Published var isEmailEnabled: Bool?
    @Published var lastName: String?
    @Published var phone: String?
    
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
    
    // MARK: - Initializers
    
    init(
        avatarImageName: String? = nil,
        bannerImageName: String? = nil,
        createdTimestamp: Int? = nil,
        deviceToken: String? = nil,
        email: String? = nil,
        eventIDs: [Int]? = nil,
        firstName: String? = nil,
        friendIDs: [Int]? = nil,
        groupIDs: [Int]? = nil,
        id: Int? = nil,
        isEmailEnabled: Bool? = nil,
        lastName: String? = nil,
        phone: String? = nil
    ) {
        self.avatarImageName = avatarImageName
        self.bannerImageName = bannerImageName
        self.createdTimestamp = createdTimestamp
        self.deviceToken = deviceToken
        self.email = email
        self.eventIDs = eventIDs
        self.firstName = firstName
        self.friendIDs = friendIDs
        self.groupIDs = groupIDs
        self.id = id
        self.isEmailEnabled = isEmailEnabled
        self.lastName = lastName
        self.phone = phone
    }
    
    convenience init(from syncedContact: SyncedContact, id: Int) {
        self.init(
            createdTimestamp: Int(Date().timeIntervalSince1970),
            eventIDs: [],
            firstName: syncedContact.fullName.components(separatedBy: " ").first,
            friendIDs: [],
            groupIDs: [],
            id: id,
            isEmailEnabled: false,
            lastName: syncedContact.fullName.components(separatedBy: " ").dropFirst().joined(separator: " "),
            phone: syncedContact.phoneNumber
        )
    }
    
    // MARK: - Equatable & Hashable
    
    static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
