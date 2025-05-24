//
//  CreateUserTests.swift
//  Gatherly-SwiftUITests
//
//  Created by Sami Alhamad on 5/8/25.
//

import XCTest
@testable import Gatherly_SwiftUI

final class CreateUserTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        UserDefaultsManager.removeUsers()
    }
    
    func makeSampleUser(id: Int? = nil, firstName: String = "Old", lastName: String = "Name") -> User {
        User(
            avatarImageName: nil,
            bannerImageName: nil,
            createdTimestamp: Int(Date().timestamp),
            email: nil,
            eventIDs: [],
            firstName: firstName,
            friendIDs: [],
            groupIDs: [],
            id: id,
            isEmailEnabled: false,
            lastName: lastName,
            phone: nil
        )
    }
    
    func testCreateUser_incrementsIDAndPersists() async {
        let user1 = makeSampleUser(firstName: "Alice", lastName: "One")
        let firstUser = await GatherlyAPI.createUser(user1)
        
        let user2 = makeSampleUser(firstName: "Bob", lastName: "Two")
        let secondUser = await GatherlyAPI.createUser(user2)
        
        let allUsers = UserDefaultsManager.loadUsers()
        XCTAssertEqual(allUsers.count, 2)
        XCTAssertEqual(secondUser.id, allUsers.map { $0.id ?? 0 }.max())
    }
    
    func testCreateUserFromContact_persistsCorrectly() async {
        let contact = SyncedContact(fullName: "Charlie Example", phoneNumber: "5551234567")
        let newUser = await GatherlyAPI.createUser(from: contact, id: 99)
        
        XCTAssertEqual(newUser.id, 99)
        XCTAssertEqual(newUser.firstName, "Charlie")
        XCTAssertEqual(newUser.lastName, "Example")
        XCTAssertEqual(newUser.phone, "5551234567")
    }
}
