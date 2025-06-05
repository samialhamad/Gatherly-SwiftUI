//
//  User.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 3/4/25.
//

import Foundation

class User: Codable, Equatable, Identifiable, ObservableObject {
    @Published var avatarImageName: String?
    @Published var bannerImageName: String?
    @Published var createdTimestamp: Int?
    @Published var firstName: String?
    @Published var friendIDs: [Int]?
    @Published var groupIDs: [Int]?
    @Published var id: Int?
    @Published var lastName: String?
    @Published var phone: String?
    
    // MARK: - Functions
    
    func friends(from lookup: [Int: User]) -> [User] {
        guard let friendIDs else {
            return []
        }
        
        return friendIDs.compactMap { lookup[$0] }
    }
    
    func groups(from groups: [UserGroup]) -> [UserGroup] {
        guard let groupIDs else {
            return []
        }
        
        return groups.filter { group in
            if let id = group.id {
                return groupIDs.contains(id)
            }
            return false
        }
    }
    
    // MARK: - Initializers
    
    init(
        avatarImageName: String? = nil,
        bannerImageName: String? = nil,
        createdTimestamp: Int? = nil,
        eventIDs: [Int]? = nil,
        firstName: String? = nil,
        friendIDs: [Int]? = nil,
        groupIDs: [Int]? = nil,
        id: Int? = nil,
        lastName: String? = nil,
        phone: String? = nil
    ) {
        self.avatarImageName = avatarImageName
        self.bannerImageName = bannerImageName
        self.createdTimestamp = createdTimestamp
        self.firstName = firstName
        self.friendIDs = friendIDs
        self.groupIDs = groupIDs
        self.id = id
        self.lastName = lastName
        self.phone = phone
    }
    
    // MARK: - Codable
    
    private enum CodingKeys: String, CodingKey {
        case avatarImageName
        case bannerImageName
        case createdTimestamp
        case firstName
        case friendIDs
        case groupIDs
        case id
        case lastName
        case phone
    }
    
    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let avatarImageName = try container.decodeIfPresent(String.self, forKey: .avatarImageName)
        let bannerImageName = try container.decodeIfPresent(String.self, forKey: .bannerImageName)
        let createdTimestamp = try container.decodeIfPresent(Int.self, forKey: .createdTimestamp)
        let firstName = try container.decodeIfPresent(String.self, forKey: .firstName)
        let friendIDs = try container.decodeIfPresent([Int].self, forKey: .friendIDs)
        let groupIDs = try container.decodeIfPresent([Int].self, forKey: .groupIDs)
        let id = try container.decodeIfPresent(Int.self, forKey: .id)
        let lastName = try container.decodeIfPresent(String.self, forKey: .lastName)
        let phone = try container.decodeIfPresent(String.self, forKey: .phone)
        
        self.init(
            avatarImageName: avatarImageName,
            bannerImageName: bannerImageName,
            createdTimestamp: createdTimestamp,
            firstName: firstName,
            friendIDs: friendIDs,
            groupIDs: groupIDs,
            id: id,
            lastName: lastName,
            phone: phone
        )
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(avatarImageName, forKey: .avatarImageName)
        try container.encode(bannerImageName, forKey: .bannerImageName)
        try container.encode(createdTimestamp, forKey: .createdTimestamp)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(friendIDs, forKey: .friendIDs)
        try container.encode(groupIDs, forKey: .groupIDs)
        try container.encode(id, forKey: .id)
        try container.encode(lastName, forKey: .lastName)
        try container.encode(phone, forKey: .phone)
    }
    
    // MARK: - Equatable
    
    static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id
    }
}
