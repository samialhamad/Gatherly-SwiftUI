//
//  DeleteGroupTests.swift
//  Gatherly-SwiftUITests
//
//  Created by Sami Alhamad on 5/8/25.
//

import Combine
import XCTest
@testable import Gatherly_SwiftUI

final class DeleteGroupTests: XCTestCase {
    
    var cancellables = Set<AnyCancellable>()
    
    override func setUp() {
        super.setUp()
        UserDefaultsManager.removeGroups()
    }
    
    func testDeleteGroup() {
        let expectation = XCTestExpectation(description: "Group is deleted from UserDefaults")
        
        var groupToDelete = UserGroup(
            id: 101,
            leaderID: 1,
            memberIDs: [],
            name: "Delete Me"
        )
        
        let groupToKeep = UserGroup(
            id: 102,
            leaderID: 2,
            memberIDs: [],
            name: "Keep Me"
        )
        
        UserDefaultsManager.saveGroups([groupToDelete, groupToKeep])
        
        GatherlyAPI.deleteGroup(groupToDelete)
            .sink { success in
                XCTAssertTrue(success, "Expected deleteGroup to return true")
                
                let storedGroups = UserDefaultsManager.loadGroups()
                
                XCTAssertEqual(storedGroups.count, 1)
                XCTAssertFalse(storedGroups.contains { $0.id == groupToDelete.id })
                XCTAssertTrue(storedGroups.contains { $0.id == groupToKeep.id })
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 2)
    }
    
    func testDeleteGroupFailsForNonexistentGroup() {
        let expectation = XCTestExpectation(description: "Deletion should fail if group doesn't exist")
        
        let fakeGroup = UserGroup(
            id: 999,
            leaderID: 1,
            memberIDs: [],
            name: "Ghost Group"
        )
        
        UserDefaultsManager.saveGroups([])
        
        GatherlyAPI.deleteGroup(fakeGroup)
            .sink { success in
                XCTAssertFalse(success, "Expected deletion to fail for non-existent group")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 2)
    }
}
