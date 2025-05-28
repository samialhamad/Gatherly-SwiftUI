//
//  CreateUserTests.swift
//  Gatherly-SwiftUITests
//
//  Created by Sami Alhamad on 5/8/25.
//

import Combine
import XCTest
@testable import Gatherly_SwiftUI

final class CreateUserTests: XCTestCase {
    
//    var cancellables = Set<AnyCancellable>()
//    
//    override func setUp() {
//        super.setUp()
//        UserDefaultsManager.removeUsers()
//    }
//    
//    func makeSampleUser(id: Int? = nil, firstName: String = "Old", lastName: String = "Name") -> User {
//        User(
//            avatarImageName: nil,
//            bannerImageName: nil,
//            createdTimestamp: Int(Date().timestamp),
//            email: nil,
//            eventIDs: [],
//            firstName: firstName,
//            friendIDs: [],
//            groupIDs: [],
//            id: id,
//            isEmailEnabled: false,
//            lastName: lastName,
//            phone: nil
//        )
//    }
//    
//    func testCreateUser_incrementsIDAndPersists() {
//        let expectation = XCTestExpectation(description: "Two users are created and persisted with unique IDs")
//        
//        let user1 = makeSampleUser(firstName: "Alice", lastName: "One")
//        let user2 = makeSampleUser(firstName: "Bob", lastName: "Two")
//        
//        var createdUsers: [User] = []
//        
//        GatherlyAPI.createUser(user1)
//            .flatMap { firstCreated -> AnyPublisher<User, Never> in
//                createdUsers.append(firstCreated)
//                return GatherlyAPI.createUser(user2)
//            }
//            .sink { secondCreated in
//                createdUsers.append(secondCreated)
//                
//                let allUsers = UserDefaultsManager.loadUsers()
//                XCTAssertEqual(allUsers.count, 2)
//                
//                let ids = allUsers.compactMap { $0.id }
//                XCTAssertTrue(ids.contains(createdUsers[0].id!))
//                XCTAssertTrue(ids.contains(createdUsers[1].id!))
//                XCTAssertNotEqual(createdUsers[0].id, createdUsers[1].id)
//                
//                expectation.fulfill()
//            }
//            .store(in: &cancellables)
//        
//        wait(for: [expectation], timeout: 3)
//    }
//    
//    func testCreateUserFromContact_persistsCorrectly() async {
//        let contact = SyncedContact(fullName: "Charlie Example", phoneNumber: "5551234567")
//        let newUser = await GatherlyAPI.createUser(from: contact, id: 99)
//        
//        XCTAssertEqual(newUser.id, 99)
//        XCTAssertEqual(newUser.firstName, "Charlie")
//        XCTAssertEqual(newUser.lastName, "Example")
//        XCTAssertEqual(newUser.phone, "5551234567")
//        
//        let allUsers = UserDefaultsManager.loadUsers()
//        XCTAssertTrue(allUsers.contains(where: { $0.id == 99 }))
//    }
}
