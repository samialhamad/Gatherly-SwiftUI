//
//  UsersViewModelTests.swift
//  Gatherly-SwiftUITests
//
//  Created by Sami Alhamad on 5/27/25.
//

import Combine
import XCTest
@testable import Gatherly_SwiftUI

final class UsersViewModelTests: XCTestCase {
    
//    var viewModel: UsersViewModel!
//    var cancellables: Set<AnyCancellable> = []
//    
//    override func setUp() {
//        super.setUp()
//        UserDefaultsManager.removeUsers()
//        viewModel = UsersViewModel()
//    }
//    
//    func makeSampleUser(id: Int = 1, firstName: String = "Test") -> User {
//        User(
//            avatarImageName: nil,
//            bannerImageName: nil,
//            createdTimestamp: Int(Date().timestamp),
//            email: "\(firstName.lowercased())@example.com",
//            eventIDs: [],
//            firstName: firstName,
//            friendIDs: [],
//            groupIDs: [],
//            id: id,
//            isEmailEnabled: false,
//            lastName: "User",
//            phone: nil
//        )
//    }
//    
//    func testLoadIfNeeded_onlyLoadsOnce() {
//        let user = makeSampleUser(id: 1)
//        UserDefaultsManager.saveUsers([user])
//        
//        let expectation = XCTestExpectation(description: "loadIfNeeded only loads once")
//        
//        viewModel.loadIfNeeded()
//        
//        viewModel.$users
//            .dropFirst()
//            .sink { users in
//                XCTAssertEqual(users.count, 1)
//                XCTAssertEqual(users.first?.id, 1)
//                
//                self.viewModel.users = []
//                self.viewModel.loadIfNeeded()
//                XCTAssertEqual(self.viewModel.users.count, 0)
//                expectation.fulfill()
//            }
//            .store(in: &cancellables)
//        
//        wait(for: [expectation], timeout: 3)
//    }
//    
//    func testForceReload_ignoresHasLoadedFlag() {
//        let user = makeSampleUser(id: 2)
//        UserDefaultsManager.saveUsers([user])
//        
//        let expectation = XCTestExpectation(description: "forceReload reloads regardless of load state")
//        
//        viewModel.forceReload()
//        
//        viewModel.$users
//            .dropFirst()
//            .sink { users in
//                XCTAssertEqual(users.count, 1)
//                XCTAssertEqual(users.first?.id, 2)
//                expectation.fulfill()
//            }
//            .store(in: &cancellables)
//        
//        wait(for: [expectation], timeout: 3)
//    }
//    
//    func testCreate_addsUserToList() {
//        let expectation = XCTestExpectation(description: "User is created and appended")
//        
//        let user = makeSampleUser(id: 234, firstName: "New")
//        
//        viewModel.create(user) { created in
//            XCTAssertNotNil(created.id)
//            XCTAssertEqual(self.viewModel.users.count, 1)
//            XCTAssertEqual(self.viewModel.users.first?.firstName, "New")
//            expectation.fulfill()
//        }
//        
//        wait(for: [expectation], timeout: 3)
//    }
//    
//    func testUpdate_updatesUserInList() {
//        let original = makeSampleUser(id: 10, firstName: "Old")
//        UserDefaultsManager.saveUsers([original])
//        
//        let expectation = XCTestExpectation(description: "User is updated in-place")
//        
//        viewModel.fetch()
//        
//        viewModel.$users
//            .dropFirst()
//            .sink { _ in
//                var updated = original
//                updated.firstName = "Updated"
//                
//                self.viewModel.update(updated)
//                
//                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
//                    XCTAssertEqual(self.viewModel.users.count, 1)
//                    XCTAssertEqual(self.viewModel.users.first?.firstName, "Updated")
//                    expectation.fulfill()
//                }
//            }
//            .store(in: &cancellables)
//        
//        wait(for: [expectation], timeout: 4)
//    }
//    
//    func testDelete_removesUserFromList() {
//        let user1 = makeSampleUser(id: 20, firstName: "Delete")
//        let user2 = makeSampleUser(id: 21, firstName: "Keep")
//        UserDefaultsManager.saveUsers([user1, user2])
//        
//        let expectation = XCTestExpectation(description: "User is deleted")
//        
//        viewModel.fetch()
//        
//        viewModel.$users
//            .dropFirst()
//            .sink { _ in
//                self.viewModel.delete(user1)
//                
//                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
//                    XCTAssertEqual(self.viewModel.users.count, 1)
//                    XCTAssertEqual(self.viewModel.users.first?.id, 21)
//                    expectation.fulfill()
//                }
//            }
//            .store(in: &cancellables)
//        
//        wait(for: [expectation], timeout: 4)
//    }
}
