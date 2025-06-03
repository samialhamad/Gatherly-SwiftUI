//
//  GroupsViewModelTests.swift
//  Gatherly-SwiftUITests
//
//  Created by Sami Alhamad on 5/27/25.
//

import Combine
import XCTest
@testable import Gatherly_SwiftUI

final class GroupsViewModelTests: XCTestCase {
    
    var viewModel: GroupsViewModel!
    var cancellables: Set<AnyCancellable> = []
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        UserDefaultsManager.removeGroups()
        viewModel = GroupsViewModel()
        cancellables = []
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        cancellables = []
        UserDefaultsManager.removeGroups()
        try super.tearDownWithError()
    }
    
    private func saveSampleGroupsToDefaults(_ groups: [UserGroup]) {
        let groupsDict = groups.keyedBy(\.id)
        UserDefaultsManager.saveGroups(groupsDict)
    }
    
    private func makeSampleGroup(id: Int?) -> UserGroup {
        return UserGroup(
            id: id,
            leaderID: 1,
            memberIDs: [],
            messages: [],
            name: "Group \(id ?? -1)"
        )
    }
    
    func testFetch() {
        let groupA = makeSampleGroup(id: 10)
        let groupB = makeSampleGroup(id: 20)
        saveSampleGroupsToDefaults([groupA, groupB])
        
        let fetchExpectation = expectation(description: "fetch() should populate viewModel.groups")
        
        var didSeeLoading = false
        
        viewModel.$isLoading
            .sink { isLoading in
                if isLoading {
                    didSeeLoading = true
                } else if didSeeLoading {
                    fetchExpectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        viewModel.$groups
            .dropFirst()
            .sink { loadedGroups in
                XCTAssertEqual(loadedGroups.count, 2)
                XCTAssertTrue(loadedGroups.contains(where: { $0.id == 10 }))
                XCTAssertTrue(loadedGroups.contains(where: { $0.id == 20 }))
            }
            .store(in: &cancellables)
        
        XCTAssertFalse(viewModel.isLoading)
        
        viewModel.fetch()
        
        wait(for: [fetchExpectation], timeout: 3.0)
        XCTAssertFalse(viewModel.isLoading)
    }
    
    func testCreate() {
        XCTAssertTrue(UserDefaultsManager.loadGroups().isEmpty)
        XCTAssertTrue(viewModel.groups.isEmpty)
        
        let newGroup = makeSampleGroup(id: nil) // API will generate one if needed
        let createExpectation = expectation(description: "create() should append a new group")
        
        viewModel.$groups
            .dropFirst()
            .sink { loadedGroups in
                XCTAssertEqual(loadedGroups.count, 1)
                XCTAssertEqual(loadedGroups.first?.name, newGroup.name)
                createExpectation.fulfill()
            }
            .store(in: &cancellables)
        
        let loadingExpectation = expectation(description: "create() toggles isLoading back to false")
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
        
        XCTAssertFalse(viewModel.isLoading)
        
        viewModel.create(newGroup) { returnedGroup in
            let stored = UserDefaultsManager.loadGroups()
            XCTAssertEqual(stored.count, 1)
            XCTAssertEqual(stored.values.first?.name, newGroup.name)
            XCTAssertNotNil(stored.values.first?.id)
        }
        
        wait(for: [createExpectation, loadingExpectation], timeout: 3.0, enforceOrder: true)
        XCTAssertFalse(viewModel.isLoading)
    }
    
    func testUpdate() {
        let originalGroup = makeSampleGroup(id: 10)
        saveSampleGroupsToDefaults([originalGroup])
        
        let fetchExpectation = expectation(description: "Initial fetch() loads the original group")
        
        viewModel.$groups
            .dropFirst()
            .first(where: { loadedGroups in
                return loadedGroups.contains(where: { $0.id == 10 })
            })
            .sink { _ in
                fetchExpectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.fetch()
        
        wait(for: [fetchExpectation], timeout: 3.0)
        
        XCTAssertEqual(viewModel.groups.count, 1)
        XCTAssertEqual(viewModel.groups.first?.id, 10)
        
        var editedGroup = originalGroup
        editedGroup.name = "Updated Group Name"
        
        let updateExpectation = expectation(description: "update() should replace the existing group")
        
        viewModel.$groups
            .dropFirst()
            .first(where: { loadedGroups in
                
                return loadedGroups.count == 1 &&
                loadedGroups.first?.name == "Updated Group Name"
            })
            .sink { _ in
                updateExpectation.fulfill()
            }
            .store(in: &cancellables)
        
        XCTAssertFalse(viewModel.isLoading)
        
        viewModel.update(editedGroup)
        
        wait(for: [updateExpectation], timeout: 2.0)
        XCTAssertFalse(viewModel.isLoading)
        
        let storedDict = UserDefaultsManager.loadGroups()
        XCTAssertEqual(storedDict.count, 1)
        XCTAssertEqual(storedDict.values.first?.name, "Updated Group Name")
    }
    
    func testDelete() {
        let groupToDelete = makeSampleGroup(id: 123)
        saveSampleGroupsToDefaults([groupToDelete])
        
        let fetchExpectation = expectation(description: "fetch() loads groupToDelete")
        viewModel.$groups
            .dropFirst()
            .first(where: { loadedGroups in
                loadedGroups.contains(where: { $0.id == 123 })
            })
            .sink { _ in
                fetchExpectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.fetch()
        
        wait(for: [fetchExpectation], timeout: 3.0)
        XCTAssertEqual(viewModel.groups.count, 1)
        
        let deleteExpectation = expectation(description: "delete() removes the group from viewModel.groups")
        
        viewModel.$groups
            .dropFirst()
            .sink { loadedGroups in
                XCTAssertTrue(loadedGroups.isEmpty)
                deleteExpectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.delete(groupToDelete)
        
        wait(for: [deleteExpectation], timeout: 2.0)
        
        let persistedAfterDelete = UserDefaultsManager.loadGroups()
        XCTAssertTrue(persistedAfterDelete.isEmpty)
    }
}
