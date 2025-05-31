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
    
    var viewModel: UsersViewModel!
    var cancellables: Set<AnyCancellable> = []
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        UserDefaultsManager.resetAll()
        viewModel = UsersViewModel()
        cancellables = []
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        cancellables = []
        try super.tearDownWithError()
    }
    
    private func makeUser(id: Int?, friendIDs: [Int]? = nil) -> User {
        return User(
            createdTimestamp: Int(Date().timeIntervalSince1970),
            deviceToken: nil,
            email: "user@example.com",
            eventIDs: nil,
            firstName: "First",
            friendIDs: friendIDs,
            groupIDs: nil,
            id: id,
            isEmailEnabled: false,
            lastName: "Last",
            phone: nil
        )
    }
    
    private func seedCurrentUserAndAllUsers(current: User, others: [User]) {
        var all = others
        all.append(current)
        UserDefaultsManager.saveUsers(all)
        UserDefaultsManager.saveCurrentUser(current)
    }
    
    func testFetch() {
        let current = makeUser(id: 1, friendIDs: [2, 3])
        let friend2 = makeUser(id: 2, friendIDs: nil)
        let friend3 = makeUser(id: 3, friendIDs: nil)
        
        seedCurrentUserAndAllUsers(current: current, others: [friend2, friend3])
        
        let loadingExpectation = expectation(description: "fetch() toggles isLoading off after data arrives")
        var sawLoading = false
        
        viewModel.$isLoading
            .sink { isLoading in
                if isLoading {
                    sawLoading = true
                } else if sawLoading {
                    loadingExpectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        let currentUserExpectation = expectation(description: "fetch() sets currentUser")
        
        viewModel.$currentUser
            .dropFirst()
            .first { publishedUser in
                return publishedUser?.id == 1
            }
            .sink { publishedUser in
                XCTAssertEqual(publishedUser?.id, 1)
                currentUserExpectation.fulfill()
            }
            .store(in: &cancellables)
        
        let friendsListExpectation = expectation(description: "fetch() sets users to friend list")
        
        viewModel.$users
            .dropFirst()
            .first { publishedUsers in
                let ids = Set(publishedUsers.compactMap { $0.id })
                return ids == Set([2, 3])
            }
            .sink { _ in
                friendsListExpectation.fulfill()
            }
            .store(in: &cancellables)
        
        XCTAssertFalse(viewModel.isLoading)
        
        viewModel.fetch()
        
        wait(for: [loadingExpectation, currentUserExpectation, friendsListExpectation], timeout: 3.0)
        
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.currentUser?.id, 1)
        XCTAssertEqual(Set(viewModel.users.compactMap { $0.id }), Set([2, 3]))
    }
    
    func testForceReloadAllowsSecondFetch() {
        let currentA = makeUser(id: 1, friendIDs: [])
        seedCurrentUserAndAllUsers(current: currentA, others: [])
        
        let firstFetchExpectation = expectation(description: "First fetch() loads user A")
        
        viewModel.$currentUser
            .dropFirst()
            .sink { publishedUser in
                if publishedUser?.id == 1 {
                    firstFetchExpectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.fetch()
        
        wait(for: [firstFetchExpectation], timeout: 3.0)
        XCTAssertEqual(viewModel.currentUser?.id, 1)
        XCTAssertTrue(viewModel.users.isEmpty)
        
        let currentB = makeUser(id: 2, friendIDs: [])
        UserDefaultsManager.saveCurrentUser(currentB)
        UserDefaultsManager.saveUsers([currentB])
        
        viewModel.loadIfNeeded()
        
        XCTAssertEqual(viewModel.currentUser?.id, 1)
        
        let secondFetchExpectation = expectation(description: "forceReload() to fetch user B")
        
        viewModel.$currentUser
            .dropFirst()
            .sink { publishedUser in
                if publishedUser?.id == 2 {
                    secondFetchExpectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.forceReload()
        wait(for: [secondFetchExpectation], timeout: 3.0)
        XCTAssertEqual(viewModel.currentUser?.id, 2)
        XCTAssertTrue(viewModel.users.isEmpty)
    }
    
    func testCreate() {
        XCTAssertTrue(UserDefaultsManager.loadUsers().isEmpty)
        XCTAssertNil(UserDefaultsManager.loadCurrentUser())
        XCTAssertTrue(viewModel.users.isEmpty)
        XCTAssertNil(viewModel.currentUser)
        
        var user = makeUser(id: nil, friendIDs: []) // API will make ID if needed
        
        let createExpectation = expectation(description: "create() should append a user to viewModel.users")
        viewModel.$users
            .dropFirst()
            .sink { publishedUsers in
                XCTAssertEqual(publishedUsers.count, 1)
                XCTAssertNotNil(publishedUsers.first?.id)
                createExpectation.fulfill()
            }
            .store(in: &cancellables)
        
        let loadingExpectation = expectation(description: "create() toggles isLoading off")
        var sawLoadingOnCreate = false
        
        viewModel.$isLoading
            .sink { isLoading in
                if isLoading {
                    sawLoadingOnCreate = true
                } else if sawLoadingOnCreate {
                    loadingExpectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        XCTAssertFalse(viewModel.isLoading)
        
        viewModel.create(user) { returnedUser in
            let loadedUsers = UserDefaultsManager.loadUsers()
            XCTAssertEqual(loadedUsers.count, 1)
            XCTAssertEqual(loadedUsers.first?.id, returnedUser.id)
        }
        
        wait(for: [createExpectation, loadingExpectation], timeout: 3.0)
        XCTAssertFalse(viewModel.isLoading)
    }
    
    func testUpdate() {
        let currentUser = makeUser(id: 1, friendIDs: [2])
        let userB = makeUser(id: 2, friendIDs: nil)
        seedCurrentUserAndAllUsers(current: currentUser, others: [userB])
        
        let fetchExpectation = expectation(description: "fetch() loads currentUser and userB")
        viewModel.$users
            .dropFirst()
            .first(where: { publishedUsers in
                return publishedUsers.contains(where: { $0.id == 2 })
            })
            .sink { _ in fetchExpectation.fulfill() }
            .store(in: &cancellables)
        
        viewModel.fetch()
        wait(for: [fetchExpectation], timeout: 3.0)
        
        XCTAssertEqual(viewModel.users.count, 1)
        XCTAssertEqual(viewModel.users.first?.id, 2)
        XCTAssertEqual(viewModel.currentUser?.id, 1)
        
        var updatedUserB = userB
        updatedUserB.firstName = "Edited Name"
        
        let updateExpectation = expectation(description: "update() should replace userB in viewModel.users")
        
        viewModel.$users
            .dropFirst()
            .first(where: { publishedUsers in
                return publishedUsers.count == 1 && publishedUsers.first?.firstName == "Edited Name"
            })
            .sink { _ in updateExpectation.fulfill() }
            .store(in: &cancellables)
        
        viewModel.update(updatedUserB)
        
        wait(for: [updateExpectation], timeout: 2.0)
        XCTAssertEqual(viewModel.users.first?.firstName, "Edited Name")
        
        let persisted = UserDefaultsManager.loadUsers()
        XCTAssertTrue(persisted.contains(where: { $0.id == 2 && $0.firstName == "Edited Name" }))
    }
    
    func testUpdateReplacesCurrentUser() {
        let currentUser = makeUser(id: 1, friendIDs: [])
        let userB = makeUser(id: 2, friendIDs: nil)
        seedCurrentUserAndAllUsers(current: currentUser, others: [userB])
        
        let fetchExpectation = expectation(description: "fetch() loads currentUser and userB")
        
        viewModel.$currentUser
            .dropFirst()
            .first { $0?.id == 1 }
            .sink { _ in
                fetchExpectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.fetch()
        
        wait(for: [fetchExpectation], timeout: 3.0)
        
        XCTAssertEqual(viewModel.currentUser?.id, 1)
        XCTAssertTrue(viewModel.users.isEmpty)
        
        var editedCurrentUser = currentUser
        editedCurrentUser.firstName = "Edited Current"
        
        let currentUpdateExpectation = expectation(description: "update() should replace currentUser")
        
        viewModel.$currentUser
            .dropFirst()
            .first { $0?.firstName == "Edited Current" }
            .sink { _ in
                currentUpdateExpectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.update(editedCurrentUser)
        
        wait(for: [currentUpdateExpectation], timeout: 2.0)
        XCTAssertEqual(viewModel.currentUser?.firstName, "Edited Current")
        
        let storedCurrent = UserDefaultsManager.loadCurrentUser()
        XCTAssertEqual(storedCurrent?.firstName, "Edited Current")
    }
    
    func testDeleteRemovesUser() {
        let currentUser = makeUser(id: 1, friendIDs: [2])
        let userB = makeUser(id: 2, friendIDs: nil)
        seedCurrentUserAndAllUsers(current: currentUser, others: [userB])
        
        let fetchExpectation = expectation(description: "fetch() loads currentUser and userB")
        
        viewModel.$users
            .dropFirst()
            .first(where: { publishedUsers in
                publishedUsers.contains(where: { $0.id == 2 })
            })
            .sink { _ in fetchExpectation.fulfill() }
            .store(in: &cancellables)
        
        viewModel.fetch()
        
        wait(for: [fetchExpectation], timeout: 3.0)
        
        XCTAssertEqual(viewModel.users.count, 1)
        XCTAssertFalse(viewModel.deletionFailed)
        
        let deleteExpectation = expectation(description: "delete() removes userB from viewModel.users")
        
        viewModel.$users
            .dropFirst()
            .sink { publishedUsers in
                XCTAssertTrue(publishedUsers.isEmpty)
                deleteExpectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.delete(userB)
        
        wait(for: [deleteExpectation], timeout: 2.0)
        XCTAssertFalse(viewModel.deletionFailed)
        
        let persisted = UserDefaultsManager.loadUsers()
        XCTAssertFalse(persisted.contains(where: { $0.id == 2 }))
    }
    
    func testDeleteReinsertsUser_andSetsDeletionFailed() {
        let orphanUser = makeUser(id: 99, friendIDs: nil)
        viewModel.users = [orphanUser]
        XCTAssertTrue(UserDefaultsManager.loadUsers().isEmpty)
        
        var seenUsers: [[User]] = []
        let removalAndReinsert = expectation(description: "two emissions: first [], then [orphanUser]")
        removalAndReinsert.expectedFulfillmentCount = 2
        
        viewModel.$users
            .dropFirst()
            .sink { publishedUsers in
                seenUsers.append(publishedUsers)
                removalAndReinsert.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.delete(orphanUser)
        
        wait(for: [removalAndReinsert], timeout: 1.0)
        XCTAssertEqual(seenUsers.count, 2)
        XCTAssertTrue(seenUsers[0].isEmpty)
        XCTAssertEqual(seenUsers[1].count, 1)
        XCTAssertEqual(seenUsers[1].first?.id, 99)
        XCTAssertTrue(viewModel.deletionFailed)
    }
}
