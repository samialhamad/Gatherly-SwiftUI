//
//  User.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/4/25.
//

import Foundation

class User: Codable, Equatable, Hashable, Identifiable, ObservableObject {
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
    
    // MARK: - Codable (Manual Implementation)

    private enum CodingKeys: String, CodingKey {
        case avatarImageName
        case bannerImageName
        case createdTimestamp
        case deviceToken
        case email
        case eventIDs
        case firstName
        case friendIDs
        case groupIDs
        case id
        case isEmailEnabled
        case lastName
        case phone
    }

    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let avatarImageName = try container.decodeIfPresent(String.self, forKey: .avatarImageName)
        let bannerImageName = try container.decodeIfPresent(String.self, forKey: .bannerImageName)
        let createdTimestamp = try container.decodeIfPresent(Int.self, forKey: .createdTimestamp)
        let deviceToken = try container.decodeIfPresent(String.self, forKey: .deviceToken)
        let email = try container.decodeIfPresent(String.self, forKey: .email)
        let eventIDs = try container.decodeIfPresent([Int].self, forKey: .eventIDs)
        let firstName = try container.decodeIfPresent(String.self, forKey: .firstName)
        let friendIDs = try container.decodeIfPresent([Int].self, forKey: .friendIDs)
        let groupIDs = try container.decodeIfPresent([Int].self, forKey: .groupIDs)
        let id = try container.decodeIfPresent(Int.self, forKey: .id)
        let isEmailEnabled = try container.decodeIfPresent(Bool.self, forKey: .isEmailEnabled)
        let lastName = try container.decodeIfPresent(String.self, forKey: .lastName)
        let phone = try container.decodeIfPresent(String.self, forKey: .phone)
        
        self.init(
            avatarImageName: avatarImageName,
            bannerImageName: bannerImageName,
            createdTimestamp: createdTimestamp,
            deviceToken: deviceToken,
            email: email,
            eventIDs: eventIDs,
            firstName: firstName,
            friendIDs: friendIDs,
            groupIDs: groupIDs,
            id: id,
            isEmailEnabled: isEmailEnabled,
            lastName: lastName,
            phone: phone
        )
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(avatarImageName, forKey: .avatarImageName)
        try container.encode(bannerImageName, forKey: .bannerImageName)
        try container.encode(createdTimestamp, forKey: .createdTimestamp)
        try container.encode(deviceToken, forKey: .deviceToken)
        try container.encode(email, forKey: .email)
        try container.encode(eventIDs, forKey: .eventIDs)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(friendIDs, forKey: .friendIDs)
        try container.encode(groupIDs, forKey: .groupIDs)
        try container.encode(id, forKey: .id)
        try container.encode(isEmailEnabled, forKey: .isEmailEnabled)
        try container.encode(lastName, forKey: .lastName)
        try container.encode(phone, forKey: .phone)
    }
    
    // MARK: - Equatable & Hashable
    
    static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
